module HtmlExtra where

import Effect (Effect)
import Prelude (Unit)
import Web.DOM.Element (Element)

foreign import innerHTML :: Element -> Effect String
foreign import setInnerHTML :: String -> Element -> Effect Unit

foreign import innerText :: Element -> Effect String
foreign import setInnerText :: String -> Element -> Effect Unit
