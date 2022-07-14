module CustomEvent where

import Prelude

import CustomEventDataType (Ui, UpdateUI, CustomData)
import CustomEventType as CustomEventType
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign (Foreign, unsafeToForeign)
import Web.Event.CustomEvent (newWithOptions, toEvent)
import Web.Event.Event (Event, EventType(..))
import Web.Event.EventTarget (dispatchEvent)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toEventTarget)
import Web.HTML.Window (document)

foreign import dispatchCustomEvent :: String -> forall r. {|r} -> Effect Unit

foreign import detail :: forall r. Event -> {|r}

foreign import logAny :: forall r. {|r} -> Effect Unit

err :: forall r. {|r} -> Effect Unit
err = dispatchCustomEvent "error-custom"

dispatchCustomEventAff :: forall r. String -> {|r} -> Aff Unit
dispatchCustomEventAff str obj= liftEffect (dispatchCustomEvent str obj)

elemNotFound ::  String -> {error :: String, description :: String}
elemNotFound str = {error: "Element not found", description: "Missing element with id='" <> str <>"'."}



dispatchCustom2 :: forall r. EventType -> {|r} -> Aff Unit
dispatchCustom2 eventType obj =  do
  event <- liftEffect $ newWithOptions eventType {bubbles: false, cancelable: false, composed: false, detail: Just obj}
  target <- liftEffect $ window >>= document <#> toEventTarget
  _ <- liftEffect $ dispatchEvent (toEvent event) target
  pure unit

dispatchCustom :: CustomData -> Aff Unit
dispatchCustom obj =  do
  event <- liftEffect $ newWithOptions CustomEventType.custom {bubbles: false, cancelable: false, composed: false, detail: Just obj}
  target <- liftEffect $ window >>= document <#> toEventTarget
  _ <- liftEffect $ dispatchEvent (toEvent event) target
  pure unit

updateUI :: UpdateUI -> Aff Unit
updateUI = dispatchCustom2 CustomEventType.update

buildCustomData :: String -> Foreign -> CustomData
buildCustomData type_ data_ = { "type": type_, "data": data_ }


ui :: Ui -> Aff Unit
ui = dispatchCustom <<< buildCustomData "ui" <<< unsafeToForeign
