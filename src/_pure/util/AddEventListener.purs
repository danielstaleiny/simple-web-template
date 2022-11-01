module AddEventListener where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Events.Utils (customEventHandlers_)
import Foreign (Foreign)
import Template.Utils as TemplateUtils
import Util.HTML (addEventListener)
import Web.Event.Event (Event)
import Web.Event.EventTarget (eventListener)
import Web.HTML.Event.EventTypes as EventType

click :: (Event -> Effect Unit) -> Effect Unit
click handler = addEventListener EventType.click =<< eventListener handler

custom :: (String -> Foreign -> Aff Unit) -> Effect Unit
custom handler = addEventListener TemplateUtils.customEventType =<< eventListener (customEventHandlers_ handler)
