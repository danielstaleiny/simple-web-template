module Placeholder  where

import Unsafe.Coerce (unsafeCoerce)

foreign import placeholder :: forall r. String -> { | r } -> String

data Test r = Test {test :: String | r}
data Nested r = Nested {profile :: {name :: String} | r}
data Profile r = Profile {name :: String, surname :: String | r}
data Other r = Other {other :: String | r}


data TestHtml = TestHtml String
data NestedHtml = NestedHtml String
data ProfileHtml = ProfileHtml String
data OtherHtml = OtherHtml String

data Template r = TestT TestHtml (Test r)
                | NestedT NestedHtml (Nested r)
                | ProfileT ProfileHtml (Profile r)
                | OtherT OtherHtml (Other r)



templateInject :: forall r. Template r -> String
templateInject (TestT (TestHtml str) (Test obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (NestedT (NestedHtml str) (Nested obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (ProfileT (ProfileHtml str) (Profile obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (OtherT (OtherHtml str) (Other obj)) = placeholder (unsafeCoerce str :: String) obj
