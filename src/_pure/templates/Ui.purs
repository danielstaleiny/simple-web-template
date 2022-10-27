module Template.Ui where

import Prelude

import Effect.Aff (Aff)
import Foreign (Foreign)
import Template.Utils as Utils

-- error :: { error :: String, description :: String } -> Aff Unit
type Template = { name :: String }

callEvent :: Template -> Aff Unit
callEvent = Utils.customEvent "ui"

template :: Foreign -> Aff Unit
template = Utils.renderRecord { box: "#box-click", template: "#template-click" }
