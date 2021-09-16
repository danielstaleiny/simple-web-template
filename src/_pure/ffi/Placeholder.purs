module Placeholder (Template(..),  templateInject) where

import Unsafe.Coerce (unsafeCoerce)

foreign import placeholder :: forall r. String -> { | r } -> String

data Template r = Test String {test :: String | r}
                | Nested String {profile :: {name :: String} | r}
                | Other String {other :: String | r}

convertToString :: forall a. a -> String
convertToString = unsafeCoerce

templateInject :: forall r.  Template r -> String
templateInject (Test str obj) = placeholder (convertToString str) obj
templateInject (Nested str obj) = placeholder (convertToString str) obj
templateInject (Other str obj) = placeholder (convertToString str) obj
