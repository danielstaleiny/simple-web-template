module Template.Utils (customEvent, customEventType, getCustomEventType, renderRecord, renderArray) where

import Prelude

import Control.Monad.Except.Trans (runExceptT)
import Data.Either (fromRight)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Dompurify (sanitize)
import Effect.Console as Console
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign (Foreign, unsafeFromForeign, unsafeToForeign, readArray)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (placeholder, placeholderArr)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.Event.CustomEvent (CustomEvent, detail, newWithOptions, toEvent)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (dispatchEvent)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toEventTarget, toParentNode)
import Web.HTML.Window (document)

type CustomData = { "type" :: String, "data" :: Foreign }
getCustomEventType :: CustomEvent -> CustomData
getCustomEventType = unsafeFromForeign <<< detail

customEvent :: forall a. String -> a -> Aff Unit
customEvent str = dispatchCustom <<< buildCustomData str <<< unsafeToForeign

customEventType :: EventType
customEventType = EventType "custom-event"

dispatchCustom :: CustomData -> Aff Unit
dispatchCustom obj =  do
  event <- liftEffect $ newWithOptions customEventType {bubbles: false, cancelable: false, composed: false, detail: Just obj}
  target <- liftEffect $ window >>= document <#> toEventTarget
  _ <- liftEffect $ dispatchEvent (toEvent event) target
  pure unit

buildCustomData :: String -> Foreign -> CustomData
buildCustomData type_ data_ = { "type": type_, "data": data_ }

-- helpLookForTemplateRecord
renderRecord :: { box :: String, template :: String } -> Foreign -> Aff Unit
renderRecord {box, template} obj = liftEffect do
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


--helpLookForTemplateArray
renderArray :: { box :: String, template :: String } -> Foreign -> Aff Unit
renderArray {box, template} arrForeign = liftEffect do
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
