module Hack where


import Prelude

import Data.Foldable (foldl)
import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (Profile(..), ProfileHtml(..), Template(..), templateInject)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (Event)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

fn :: forall r. ProfileHtml -> String -> (Profile r) -> String
fn html acc item =  fnT acc $ ProfileT html item

fnT :: forall r. String -> (Template r) -> String
fnT acc item =  acc <> templateInject item

hack :: Event -> Aff Unit
hack _ = liftEffect do
  document_ <- window >>= document >>= toNonElementParentNode >>> pure
  let getById str = getElementById str document_
  box_      <- getById "ul"
  template_ <- getById "template-item"
  let arr = [Profile({name:"Dan", surname: "Stale"}), Profile({name: "Druhy", surname: "User"})]
  case box_, template_ of
    (Just box), (Just template) -> do
      html <- innerHTML template >>= ProfileHtml >>> pure
      html' <- sanitize $ foldl (fn html) "" arr
      -- let arr' = [ProfileT (Profile ({name:"Dan", surname: "Stale"})), ProfileT (Profile ({name: "Druhy", surname: "User"}))]
      -- html' <- sanitize $ foldl (fnT html) "" arr'
      setInnerHTML html' box
    _ , _ -> pure unit
