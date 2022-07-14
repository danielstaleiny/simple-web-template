module AddEventListeners where

import Prelude

import CustomEvent (getCustomEventType)
import CustomEvent as CustomEvent
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (error)
import EventListener.Click (click)
import Foreign (Foreign)
import Templates as Template
import Util.EventCatcher (matches)
import Util.HTML (addEventListener, ifThen)
import Web.Event.CustomEvent (fromEvent)
import Web.Event.Event (Event)
import Web.Event.EventTarget (eventListener)
import Web.HTML.Event.EventTypes as EventType



clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  matches evt "[click='click']" >>= ifThen click

customEventHandlers_ :: Event -> Effect Unit
customEventHandlers_ evt = launchAff_ do
  case getCustomEventType <$> fromEvent evt of
    (Just obj) -> customEventHandlers obj."type" obj."data"
    (Nothing) -> liftEffect $ error "You are calling 'customEventHandlers_' CustomEvent in nonCustomEvent listener!"

customEventHandlers :: String -> Foreign -> Aff Unit
customEventHandlers "error" = Template.error
customEventHandlers "ui" = Template.ui
customEventHandlers str = \_ -> liftEffect $ error $ "CustomEventHandlerType not found among customEventHandlers! type='" <> str <> "'"


addEventListeners :: Effect Unit
addEventListeners = do
  -- Click event listeners
  addEventListener EventType.click =<< eventListener clickEventListeners
  -- Custom event listeners
  addEventListener CustomEvent.customEventType =<< eventListener customEventHandlers_
