module Template.List where

import Prelude

import Effect.Aff (Aff)
import Foreign (Foreign)
import Template.Utils as Utils

type Template = Array { name :: String }

callEvent :: Template -> Aff Unit
callEvent = Utils.customEvent "list"

template :: Foreign -> Aff Unit
template = Utils.renderArray { box: "#box-click", template: "#template-click" }
