module ProductShow where


import Prelude

import CustomEvent (elemNotFound, err)
import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (Product(..), ProductHtml(..), Template(..), templateInject)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (Event)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)



productShow :: Int -> Event -> Aff Unit
productShow n _ = liftEffect do
  document_ <- window >>= document >>= toNonElementParentNode >>> pure
  let getById str = getElementById str document_

  box_ <- getById "box"
  template_ <- getById "product-template"
  case box_, template_ of
    (Just box), (Just template) -> do
      html <- innerHTML template
      html_ <- sanitize $ templateInject (ProductT (ProductHtml html) (Product {product: {title: "Product title "<> (show n), description: "Description of the product " <> (show n)} }))
      setInnerHTML html_ box
    Nothing, _ -> err <<< elemNotFound $ "box"
    _, Nothing -> err {error: "Fix your html", description: "'product-template' id not found in your html!"}
