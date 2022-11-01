module Events.AddEventListeners where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import EventListener.Click (click)
import Events.Utils (customEventHandlers_)
import Template.Events (customEventHandlers)
import Template.Utils as TemplateUtils
import Util.EventCatcher (matches)
import Util.HTML (addEventListener, ifThen)
import Web.Event.Event (Event)
import Web.Event.EventTarget (eventListener)
import Web.HTML.Event.EventTypes as EventType

clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  -- Cost to pass event to everyfunction is very little.
  -- Therefore we don not split events for everypage but re-use this function for all the pages instead.
  matches evt "[click='click']" >>= ifThen click

addEventListeners :: Effect Unit
addEventListeners = do
  -- Click event listeners
  addEventListener EventType.click =<< eventListener clickEventListeners
  -- Custom event listeners
  addEventListener TemplateUtils.customEventType =<< eventListener (customEventHandlers_ customEventHandlers)
