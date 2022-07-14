module Templates where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console as Console
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (placeholder)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.HTML.Window (document)



helpLookForTemplate :: forall r. { box :: String, template :: String } -> { |r } -> Effect Unit
helpLookForTemplate {box, template} obj = do
  document_ <- window >>= document >>= toParentNode >>> pure
  maybeBox <- querySelector (QuerySelector box) document_
  maybeTemplate <- querySelector (QuerySelector template) document_
  case maybeBox, maybeTemplate of
    (Just boxElem),(Just template_) -> do
      templateHTML <- innerHTML template_
      html <- sanitize $ placeholder templateHTML obj
      setInnerHTML html boxElem
    Nothing, Nothing -> Console.error $ "Template and Box was not found by querySelectors: '" <> template <> "', '" <> box <> "'"
    Nothing, (Just _) -> Console.error $ "Box was not found by querySelector: '" <> box <> "'"
    (Just _), Nothing -> Console.error $ "Template was not found by querySelector: '" <> template <> "'"


error :: { error :: String, description :: String } -> Effect Unit
error = helpLookForTemplate { box: "#box-click", template: "#error-template" }


click :: { name :: String } -> Aff Unit
click = liftEffect <<< helpLookForTemplate { box: "#box-click", template: "#template-click" }
