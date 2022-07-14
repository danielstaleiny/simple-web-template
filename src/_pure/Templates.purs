module Templates where

import Prelude

import Data.Maybe (Maybe(..))
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console as Console
import Foreign (Foreign)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (placeholder)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.HTML.Window (document)

helpLookForTemplate :: { box :: String, template :: String } -> Foreign -> Effect Unit
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


-- error :: { error :: String, description :: String } -> Aff Unit
type Error = { name :: String }
error :: Foreign -> Aff Unit
error = liftEffect <<< helpLookForTemplate { box: "#box-error", template: "#template-error" }

type Ui = { name :: String }
ui :: Foreign -> Aff Unit
ui = liftEffect <<< helpLookForTemplate { box: "#box-click", template: "#template-click" }
