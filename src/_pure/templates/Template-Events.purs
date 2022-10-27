module Template.Events where

import Prelude
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console as Log
import Foreign (Foreign)
import Template.Error as Error
import Template.List as List
import Template.Ui as Ui

customEventHandlers :: String -> Foreign -> Aff Unit
customEventHandlers "error" = Error.template
customEventHandlers "ui" = Ui.template
customEventHandlers "list" = List.template
customEventHandlers str = \_ -> liftEffect $ Log.error $ "CustomEventHandlerType not found among customEventHandlers! type='" <> str <> "'"
