module Clack where


import Prelude
import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (Template(..), templateInject)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (Event)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)


clack :: Event -> Aff Unit
clack _ = liftEffect do
  document_ <- window >>= document >>= toNonElementParentNode >>> pure
  let getById str = getElementById str document_

  box_ <- getById "box"
  template_ <- getById "test-template"
  case box_, template_ of
    (Just box), (Just template) -> do
      html <- innerHTML template
      html_ <- sanitize $ templateInject (Nested html {profile: {name: "Daniel"}, so: "oau"})
      setInnerHTML html_ box
    _, _ -> pure unit
