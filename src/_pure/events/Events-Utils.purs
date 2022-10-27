module Events.Utils where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (error)
import Foreign (Foreign)
import Template.Utils (getCustomEventType)
import Web.Event.CustomEvent (fromEvent)
import Web.Event.Event (Event)

customEventHandlers_ :: (String -> Foreign -> Aff Unit) -> Event -> Effect Unit
customEventHandlers_ customEventsResolver evt  = launchAff_ do
  case getCustomEventType <$> fromEvent evt of
    (Just obj) -> customEventsResolver obj."type" obj."data"
    (Nothing) -> liftEffect $ error "You are calling 'customEventHandlers_' CustomEvent in nonCustomEvent listener!"
