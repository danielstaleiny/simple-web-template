module EventListeners where

import Prelude

import Clack (clack)
import CustomEvent (detail, logAny)
import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Effect.Console as Console
import ErrorEvent (errorEvent)
import Event (isSelectorEvent)
import Hack (hack)
import HtmlExtra (ctrlKey, innerHTML, setInnerHTML)
import IfThen (ifThen)
import Placeholder (Error(..), ErrorHtml(..), Template(..), templateInject)
import ProductShow (productShow)
import Test (fetchHtmlAndRender, loadPage, windowTarget)
import Web.DOM.Element (getAttribute)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (Event, EventType(..), preventDefault, target)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes (click)
import Web.HTML.HTMLAnchorElement (fromEventTarget, rel, toElement)
import Web.HTML.HTMLDocument (toEventTarget, toNonElementParentNode)
import Web.HTML.Window (document)


cluck :: Event -> Aff Unit
cluck _ = liftEffect $ log "cluck"

          
clickAnchor :: Event -> Aff Unit
clickAnchor evt = do
  isCtrl <- liftEffect $ ctrlKey evt
  case isCtrl of
    true -> pure unit
    false -> do
      liftEffect $ preventDefault evt
      let a_ = (target evt) >>= fromEventTarget
      case a_ of
        (Just a) -> do
          str_ <- liftEffect $ getAttribute "href" (toElement a)
          case str_ of
            (Just str) -> do
              liftEffect $ fetchHtmlAndRender str
            Nothing -> pure unit
        Nothing -> pure unit


clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  let isSelector = isSelectorEvent evt

  isSelector "[href]" >>= ifThen (clickAnchor evt)

  isSelector "[click='clack']" >>= ifThen (clack evt)
  isSelector "[click='cluck']" >>= ifThen (cluck evt)
  isSelector "[click='hack']" >>= ifThen (hack evt)
  isSelector "[click='hack']" >>= ifThen (errorEvent evt)
  isSelector "[click='product2']" >>= ifThen (productShow 2 evt)
  isSelector "[click='product3']" >>= ifThen (productShow 3 evt)
  isSelector "[click='product4']" >>= ifThen (productShow 4 evt)
  isSelector "[click='product5']" >>= ifThen (productShow 5 evt)

  
errorListeners :: Event -> Effect Unit
errorListeners evt = launchAff_ do
  -- do http post to log error
  document_ <- liftEffect $ window >>= document >>= toNonElementParentNode >>> pure
  let getById str = liftEffect $ getElementById str document_
  box_ <- liftEffect $ getById "error"
  template_ <- liftEffect $ getById "error-template"
  case box_, template_ of
    (Just box), (Just template) -> do
      html <- liftEffect $ innerHTML template
      html_ <- liftEffect $  sanitize $ templateInject (ErrorT (ErrorHtml html) (Error (detail evt)))
      liftEffect $ setInnerHTML html_ box
    _,_ -> liftEffect $ Console.error "Error logging broken!!"
  liftEffect $ logAny $ detail evt
  



popstateEventListeners :: Event -> Effect Unit
popstateEventListeners evt = do
  loadPage
                             




addEventListeners :: Effect Unit
addEventListeners = do
  clickEventListeners_ <- eventListener clickEventListeners
  errorEventListeners <- eventListener errorListeners
  popstateEventListeners_ <- eventListener popstateEventListeners

  window_ <- windowTarget
  document_ <- window >>= document

  -- Click event listener
  addEventListener click clickEventListeners_ false (toEventTarget document_)

  -- Custom event listener
  addEventListener (EventType "error-custom") errorEventListeners false (toEventTarget document_)


  addEventListener (EventType "popstate") popstateEventListeners_ false window_

  -- window.onpopstate = () => setTimeout(doSomeThing, 0);
