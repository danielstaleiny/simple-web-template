module EventListeners where

import Prelude

import CustomEvent (dispatchCustomEventAff)
import CustomEvent as CustomEvent
import CustomEvent as DOM
import CustomEvent as Dispatch
import CustomEvent as Emit
import CustomEvent as Render
import CustomEvent as UI
import CustomEventDataType as CustomeEventDataType
import CustomEventType as CustomEventType
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), maybe)
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (error, log, logShow)
import Effect.Console as Console
import EventCatcher (EventObj, matches)
import Foreign (Foreign, unsafeFromForeign)
import HtmlExtra (ctrlKey, innerHTML, setInnerHTML)
import Templates as Template
import Test (fetchHtmlAndRender, loadPage, windowTarget)
import Web.DOM.Element (Element, getAttribute)
import Web.DOM.NonElementParentNode (getElementById)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.Event.CustomEvent (detail, fromEvent, newWithOptions, toEvent)
import Web.Event.Event (Event, EventType(..), preventDefault, target)
import Web.Event.EventTarget (EventListener, dispatchEvent, eventListener)
import Web.Event.EventTarget as EventTarget
import Web.HTML (window)
import Web.HTML.Event.EventTypes as EventType
import Web.HTML.HTMLAnchorElement (fromEventTarget, rel, toElement)
import Web.HTML.HTMLDocument (toEventTarget, toNonElementParentNode, toParentNode)
import Web.HTML.Window (document)


cluck :: Event -> Aff Unit
cluck _ = liftEffect $ log "cluck"

-- click :: Event -> Element -> Aff Unit
-- click _ _ = liftEffect $ log "click"





click :: {event :: Event, element :: Element } -> Aff Unit
click { event, element } = do
  Render.ui {name: "UI"}


  -- maybeBox <- liftEffect $ querySelector (QuerySelector boxQuery) document_
  -- case maybeBox of
  --   Nothing -> liftEffect $ log $ "Box was not found: " <> boxQuery
  --   (Just box) -> do
  --     template_ <- liftEffect $ Template.click {name: "hoooyyy"}
  --     case template_ of
  --       (Right template) -> do
  --         liftEffect $ setInnerHTML template box
  --       (Left err) -> liftEffect $ log err



  --     html_ <- liftEffect $  sanitize $ templateInject (ErrorT (ErrorHtml html) (Error (detail evt)))
  --     liftEffect $ setInnerHTML html_ box

  liftEffect $ log "click"





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

-- (<*>) apply  :: f (a -> b) -> f a -> f b
-- (<$>) map  :: (a -> b) -> f a -> f b
-- (>>=) bind  :: m a -> (a -> m b) -> m b
-- (>=>) kleisly arrow  :: (a -> m b) -> (b -> m c) -> a -> m c

ifThen :: (EventObj -> Aff Unit) -> Maybe EventObj -> Aff Unit
ifThen fn maybeObj = maybe stopExecution fn maybeObj
  where
    stopExecution = pure unit

sush :: Foreign -> Aff Unit
sush _ = pure unit

      -- liftEffect $ Template.click obj
customEventHandlers :: String -> Foreign -> Aff Unit
customEventHandlers "ui" = Template.click <<< CustomeEventDataType.ui
customEventHandlers _ = sush


updateUI :: Event -> Effect Unit
updateUI evt = launchAff_ do
  case CustomeEventDataType.getType <$> fromEvent evt of
    (Just obj) -> customEventHandlers obj."type" obj."data"

    (Nothing) -> liftEffect $ error "You are calling updateUI CustomEvent in nonCustomEvent listener!"

updateUI2 :: Event -> Effect Unit
updateUI2 evt = launchAff_ do
  let obj_ = CustomeEventDataType.updateUI <$> fromEvent evt
  case obj_ of
    (Just obj) -> do
      liftEffect $ log "updating UI"
      Template.click obj
    (Nothing) -> liftEffect $ error "You are calling updateUI2 CustomEvent in nonCustomEvent listener!"
  -- matches evt "[click='click']" >>= ifThen click


clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  matches evt "[click='click']" >>= ifThen click

  -- isSelector "[href]" >>= ifThen (clickAnchor evt)

  -- isSelector "[click='clack']" >>= ifThen (clack evt)
  -- isSelector "[click='cluck']" >>= ifThen (cluck evt)
  -- isSelector "[click='hack']" >>= ifThen (hack evt)
  -- isSelector "[click='hack']" >>= ifThen (errorEvent evt)
  -- isSelector "[click='product2']" >>= ifThen (productShow 2 evt)
  -- isSelector "[click='product3']" >>= ifThen (productShow 3 evt)
  -- isSelector "[click='product4']" >>= ifThen (productShow 4 evt)
  -- isSelector "[click='product5']" >>= ifThen (productShow 5 evt)

  
errorListeners :: Event -> Effect Unit
errorListeners evt = launchAff_ do
  -- do http post to log error
  document_ <- liftEffect $ window >>= document >>= toNonElementParentNode >>> pure
  let getById str = liftEffect $ getElementById str document_
  box_ <- liftEffect $ getById "error"
  template_ <- liftEffect $ getById "error-template"
  -- case box_, template_ of
  --   (Just box), (Just template) -> do
  --     html <- liftEffect $ innerHTML template
  --     html_ <- liftEffect $  sanitize $ templateInject (ErrorT (ErrorHtml html) (Error (detail evt)))
  --     liftEffect $ setInnerHTML html_ box
  --   _,_ -> liftEffect $ Console.error "Error logging broken!!"
  pure unit
  -- liftEffect $ logAny $ detail evt
  



popstateEventListeners :: Event -> Effect Unit
popstateEventListeners evt = do
  pure unit
  -- loadPage
                             



addEventListener :: EventType -> EventListener -> Effect Unit
addEventListener type_ listener = EventTarget.addEventListener type_ listener false =<< (window >>= document <#> toEventTarget)

addEventListeners :: Effect Unit
addEventListeners = do

  -- Click event listeners
  addEventListener EventType.click =<< eventListener clickEventListeners
  -- Custom event listeners
  addEventListener CustomEventType.update =<< eventListener updateUI2
  addEventListener CustomEventType.error =<< eventListener errorListeners
  addEventListener CustomEventType.custom =<< eventListener updateUI
