module CustomEvent where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign (Foreign, unsafeFromForeign, unsafeToForeign)
import Templates as Template
import Web.Event.CustomEvent (CustomEvent, detail, newWithOptions, toEvent)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (dispatchEvent)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toEventTarget)
import Web.HTML.Window (document)


customEventType :: EventType
customEventType = EventType "custom-event"

type CustomData = { "type" :: String, "data" :: Foreign }
getCustomEventType :: CustomEvent -> CustomData
getCustomEventType = unsafeFromForeign <<< detail

dispatchCustom :: CustomData -> Aff Unit
dispatchCustom obj =  do
  event <- liftEffect $ newWithOptions customEventType {bubbles: false, cancelable: false, composed: false, detail: Just obj}
  target <- liftEffect $ window >>= document <#> toEventTarget
  _ <- liftEffect $ dispatchEvent (toEvent event) target
  pure unit

buildCustomData :: String -> Foreign -> CustomData
buildCustomData type_ data_ = { "type": type_, "data": data_ }

error :: Template.Error -> Aff Unit
error = dispatchCustom <<< buildCustomData "error" <<< unsafeToForeign

ui :: Template.Ui -> Aff Unit
ui = dispatchCustom <<< buildCustomData "ui" <<< unsafeToForeign
