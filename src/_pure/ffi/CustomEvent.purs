module CustomEvent where

import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Web.Event.Event (Event)

foreign import dispatchCustomEvent :: String -> forall r. {|r} -> Effect Unit

foreign import detail :: forall r. Event -> {|r}

foreign import logAny :: forall r. {|r} -> Effect Unit

err :: forall r. {|r} -> Effect Unit
err = dispatchCustomEvent "error-custom"

dispatchCustomEventAff :: String -> forall r. {|r} -> Aff Unit
dispatchCustomEventAff str obj= liftEffect (dispatchCustomEvent str obj)

elemNotFound ::  String -> {error :: String, description :: String}
elemNotFound str = {error: "Element not found", description: "Missing element with id='" <> str <>"'."}
