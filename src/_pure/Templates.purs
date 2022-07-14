module Templates where

import Prelude

import Control.Monad.Except.Trans (runExceptT)
import Data.Array (foldMap)
import Data.Either (fromRight)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Debug (traceM)
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log, logShow)
import Effect.Console as Console
import Foreign (Foreign, readArray)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (placeholder, placeholderArr)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.HTML.Window (document)

helpLookForTemplateRecord :: { box :: String, template :: String } -> Foreign -> Effect Unit
helpLookForTemplateRecord  {box, template} obj = do
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


helpLookForTemplateArray :: { box :: String, template :: String } -> Foreign -> Effect Unit
helpLookForTemplateArray  {box, template} arrForeign = do
  arr_ <- runExceptT $ readArray arrForeign
  let arr = fromRight [] arr_
  document_ <- window >>= document >>= toParentNode >>> pure
  maybeBox <- querySelector (QuerySelector box) document_
  maybeTemplate <- querySelector (QuerySelector template) document_
  case maybeBox, maybeTemplate of
    (Just boxElem),(Just template_) -> do
      templateHTML <- innerHTML template_
      -- TODO make it possible to add wrapper as well. like <ul>li,li,li</ul>
      html <- sanitize $ joinWith "\n" $ placeholderArr templateHTML arr
      setInnerHTML html boxElem
    Nothing, Nothing -> Console.error $ "Template and Box was not found by querySelectors: '" <> template <> "', '" <> box <> "'"
    Nothing, (Just _) -> Console.error $ "Box was not found by querySelector: '" <> box <> "'"
    (Just _), Nothing -> Console.error $ "Template was not found by querySelector: '" <> template <> "'"


-- error :: { error :: String, description :: String } -> Aff Unit
type Error = { name :: String }
error :: Foreign -> Aff Unit
error = liftEffect <<< helpLookForTemplateRecord { box: "#box-error", template: "#template-error" }

type Ui = { name :: String }
ui :: Foreign -> Aff Unit
ui = liftEffect <<< helpLookForTemplateRecord { box: "#box-click", template: "#template-click" }


type List = Array { name :: String }
list :: Foreign -> Aff Unit
list = liftEffect <<< helpLookForTemplateArray { box: "#box-click", template: "#template-click" }
