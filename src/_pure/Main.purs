module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (Template(..), templateInject)
import Web.DOM.Element (fromEventTarget, matches)
import Web.DOM.NonElementParentNode (getElementById)
import Web.DOM.ParentNode (QuerySelector(..))
import Web.Event.Event (Event, target)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes (click)
import Web.HTML.HTMLDocument (toEventTarget, toNonElementParentNode)
import Web.HTML.Window (document)


isSelectorEvent :: Event -> String -> Aff Boolean
isSelectorEvent evt selector = do
  case (fromEventTarget =<< target evt) of
    Nothing -> pure false
    (Just elem) -> liftEffect $ matches (QuerySelector selector) elem

ifThen :: Aff Unit -> Boolean  -> Aff Unit
ifThen _ false  = pure unit
ifThen f true  = f

clack :: Event -> Aff Unit
clack _ = liftEffect do
  document_ <- window >>= document >>= toNonElementParentNode >>> pure
  let getById str = getElementById str document_

  box_ <- getById "box"
  template_ <- getById "test-template"
  case box_, template_ of
    (Just box), (Just template) -> do
      html <- innerHTML template
      html_ <- sanitize $ templateInject (Nested html {profile: {name: "Daniel"}, so: "oau"})
      setInnerHTML html_ box
    _, _ -> pure unit

cluck :: Event -> Aff Unit
cluck _ = liftEffect $ log "cluck"


clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  let isSelector = isSelectorEvent evt

  isSelector "[click='clack']" >>= ifThen (clack evt)
  isSelector "[click='cluck']" >>= ifThen (cluck evt)


addEventListeners :: Effect Unit
addEventListeners = do
  clickEventListeners_ <- eventListener clickEventListeners
  document_ <- window >>= document

  -- Click event listener
  addEventListener click clickEventListeners_ false (toEventTarget document_)


main :: Effect Unit
main = do
  addEventListeners



-- // const el = template.content.firstElementChild.cloneNode(true)
-- // el.innerHTML = placeholders(el.innerHTML, data)
-- // container.appendChild(el)


  log "works log"
  -- log $ templateInject (Test "<p>[[test]]</p>" {test: "hello", so: "oau"})
  -- log $ templateInject (Other "<p>[[other]]</p>" {other: "other txt", extra: "extra"})
