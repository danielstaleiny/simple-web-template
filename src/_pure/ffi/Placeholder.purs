module Placeholder  where

import Unsafe.Coerce (unsafeCoerce)

foreign import placeholder :: forall r. String -> { | r } -> String

newtype Test r = Test {test :: String | r}
newtype Nested r = Nested {profile :: {name :: String} | r}
newtype Profile r = Profile {name :: String, surname :: String | r}
newtype Other r = Other {other :: String | r}
newtype Error r = Error {error :: String, description :: String | r}
newtype Product r = Product {product :: { title :: String, description :: String } | r}


newtype TestHtml = TestHtml String
newtype NestedHtml = NestedHtml String
newtype ProfileHtml = ProfileHtml String
newtype OtherHtml = OtherHtml String
newtype ErrorHtml = ErrorHtml String
newtype ProductHtml = ProductHtml String

data Template r = TestT TestHtml (Test r)
                | NestedT NestedHtml (Nested r)
                | ProfileT ProfileHtml (Profile r)
                | OtherT OtherHtml (Other r)
                | ErrorT ErrorHtml (Error r)
                | ProductT ProductHtml (Product r)



templateInject :: forall r. Template r -> String
templateInject (TestT (TestHtml str) (Test obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (NestedT (NestedHtml str) (Nested obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (ProfileT (ProfileHtml str) (Profile obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (OtherT (OtherHtml str) (Other obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (ErrorT (ErrorHtml str) (Error obj)) = placeholder (unsafeCoerce str :: String) obj
templateInject (ProductT (ProductHtml str) (Product obj)) = placeholder (unsafeCoerce str :: String) obj
