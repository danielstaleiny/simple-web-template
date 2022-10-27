module Template.Error where

import Prelude

import Effect.Aff (Aff)
import Foreign (Foreign)
import Template.Utils as Utils

-- error :: { error :: String, description :: String } -> Aff Unit
type Template = { name :: String }

callEvent :: Template -> Aff Unit
callEvent = Utils.customEvent "error"

template :: Foreign -> Aff Unit
template = Utils.renderRecord { box: "#box-error", template: "#template-error" }
