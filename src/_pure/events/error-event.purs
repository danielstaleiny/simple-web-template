module ErrorEvent where


import Prelude

import CustomEvent (elemNotFound, err)
import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import HtmlExtra (innerHTML, setInnerHTML)
-- import Placeholder (Error(..), ErrorHtml(..), Template(..), templateInject)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (Event)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)


-- errorEvent :: Event -> Aff Unit
-- errorEvent _ = liftEffect do
--   document_ <- window >>= document >>= toNonElementParentNode >>> pure
--   let getById str = getElementById str document_
--   box_ <- getById "error"
--   template_ <- getById "error-templatea"
--   case box_, template_ of
--     (Just box), (Just template) -> do
--       html <- innerHTML template
--       html_ <- sanitize $ templateInject (ErrorT (ErrorHtml html) (Error {error: "Missing something, raised error", description: "try something else"}))
--       setInnerHTML html_ box
--     Nothing, _ -> err <<< elemNotFound $ "error"
--     _, Nothing -> err <<< elemNotFound $ "error-template"
