module Placeholder  where

import Foreign (Foreign)

foreign import placeholder :: String -> Foreign -> String

foreign import placeholderArr :: String -> Array Foreign -> Array String
