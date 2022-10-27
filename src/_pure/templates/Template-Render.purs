module Template.Render where

import Prelude
import Effect.Aff (Aff)
import Template.Error as Error
import Template.List as List
import Template.Ui as Ui

error :: { name :: String } -> Aff Unit
error = Error.callEvent

ui :: { name :: String } -> Aff Unit
ui = Ui.callEvent

list :: Array { name :: String } -> Aff Unit
list = List.callEvent
