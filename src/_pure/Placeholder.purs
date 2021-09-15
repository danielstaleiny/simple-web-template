module Placeholder where

import Data.Show (show)

foreign import placeholder :: forall r. String -> { | r } -> String

data Template r = Test String {test :: String | r}
              | Other String {other :: String | r}

templateInject :: forall r.  Template r -> String
templateInject (Test str obj) = placeholder (show str) obj
templateInject (Other str obj) = placeholder (show str) obj
