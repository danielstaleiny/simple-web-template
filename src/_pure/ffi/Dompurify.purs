module Dompurify where

import Effect (Effect)

foreign import sanitize :: String -> Effect String
