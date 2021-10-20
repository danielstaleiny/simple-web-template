module HtmlExtra where

import Effect (Effect)
import Prelude (Unit)
import Web.DOM.Element (Element)
import Web.Event.Event (Event)

foreign import innerHTML :: Element -> Effect String
foreign import setInnerHTML :: String -> Element -> Effect Unit

foreign import innerText :: Element -> Effect String
foreign import setInnerText :: String -> Element -> Effect Unit

foreign import ctrlKey :: Event -> Effect Boolean
