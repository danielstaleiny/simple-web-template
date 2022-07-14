module CustomEventDataType where

import Prelude

import Foreign (Foreign, unsafeFromForeign)
import Web.Event.CustomEvent (CustomEvent, detail)

type UpdateUI = { name :: String }
updateUI :: CustomEvent -> UpdateUI
updateUI = unsafeFromForeign <<< detail


type CustomData = { "type" :: String, "data" :: Foreign }
getType :: CustomEvent -> CustomData
getType = unsafeFromForeign <<< detail


type Ui = { name :: String }
ui :: Foreign -> Ui
ui = unsafeFromForeign
