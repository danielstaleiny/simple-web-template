module Framework where

import Prelude

import Config (Environment, environment)
import Control.Monad.Except.Trans (class MonadThrow, ExceptT, runExceptT, throwError)
import Control.Monad.Reader.Trans (ReaderT, runReaderT)
import Data.Either (Either(..), fromRight)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Debug as Debug
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Foreign (Foreign, readArray, unsafeFromForeign, unsafeToForeign)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (placeholder, placeholderArr)
import Web.DOM (Element, ParentNode)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.Event.CustomEvent (CustomEvent, detail, fromEvent, newWithOptions, toEvent)
import Web.Event.Event (Event, EventType(..))
import Web.Event.EventTarget (dispatchEvent)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toEventTarget, toParentNode)
import Web.HTML.Window as Window

getCustomEventType :: CustomEvent -> CustomData
getCustomEventType = unsafeFromForeign <<< detail

renderUI ::  forall m. -- AppM
          MonadAff m =>
          MonadThrow String m =>
          WriteToHtml m =>
          Event ->
          m Unit
renderUI evt = do
  obj <- getCustomEventObject evt
  writeToHtml obj

customEventListeners :: Event -> Effect Unit
customEventListeners ev = launchAff_ do
  -- Use 'custom-event' for all the event on the site
  -- Instead of creating different custom-event, use type_ to do different logic
  -- Similiar how we did it in Click events.
  runApp (renderUI ev) environment



-- Capability type classes:
class (Monad m) <= DebugFunctions m where
  log :: String -> m Unit
  logM :: forall a. a -> m Unit

class (Monad m) <= QueryHtml m where
  query :: ParentNode -> String -> m Element
  document :: m ParentNode

class (Monad m) <= WriteToHtml m where
  getCustomEventObject :: Event -> m CustomData
  writeToHtml :: CustomData -> m Unit
  renderRecord :: CustomData -> m Unit
  renderArray :: CustomData -> m Unit

-- Layer 2 (Production)

newtype AppM a = AppM (ReaderT Environment (ExceptT String Aff) a)
derive newtype instance functorTestM    :: Functor AppM
derive newtype instance applyAppM       :: Apply AppM
derive newtype instance Applicative AppM
derive newtype instance bindAppM        :: Bind AppM
derive newtype instance monadAppM       :: Monad AppM
derive newtype instance monadEffectAppM     :: MonadEffect AppM
derive newtype instance monadAffAppM        :: MonadAff AppM
derive newtype instance monadErrorAppM :: MonadThrow String AppM

runApp :: forall a. AppM a -> Environment -> Aff Unit
runApp (AppM reader_T) env = do
  res <- runExceptT $ runReaderT reader_T env
  case res of
    (Right _) -> do
      pure unit
    (Left err) -> do
      -- TODO emit error with error event handler, custom-event Error.
      liftEffect $ Console.log err
      pure unit


-- Layer 1 (the implementations of each instance)

instance DebugFunctions AppM where
  log = liftEffect <<< Console.log
  logM = liftEffect <<< Debug.logM <<< unsafeToForeign

-- instance monadAskAppMA :: TypeEquals e Environment => MonadAsk e AppMA where
--   ask = AppMA $ asks from

buildCustomData :: {type_ :: String, type_input :: String, box :: String, template :: String} -> Foreign -> CustomData
buildCustomData { type_, type_input, box, template } data_ = { "type_": type_, "type_input": type_input, "box": box, template: template, "data": data_ }

customEventType :: EventType
customEventType = EventType "custom-event"

type CustomData = { type_ :: String, type_input ::String, box :: String, template :: String, "data" :: Foreign }
dispatchCustom :: CustomData -> Aff Unit
dispatchCustom obj =  do
  event <- liftEffect $ newWithOptions customEventType {bubbles: false, cancelable: false, composed: false, detail: Just obj}
  target <- liftEffect $ window >>= Window.document <#> toEventTarget
  _ <- liftEffect $ dispatchEvent (toEvent event) target
  pure unit

customEvent :: forall a. {type_ :: String, type_input :: String, box :: String, template :: String} -> a -> Aff Unit
customEvent obj = dispatchCustom <<< buildCustomData obj <<< unsafeToForeign


instance QueryHtml AppM where
  query target q = do
    mElem <- liftEffect $ querySelector (QuerySelector q) target
    case mElem of
      (Just elem) -> pure elem
      (Nothing) -> throwError $ "'" <> q <> "' Element was not found by querySelector"

  document = liftEffect $ window >>= Window.document >>= toParentNode >>> pure


instance WriteToHtml AppM where
  getCustomEventObject evt = do
    case getCustomEventType <$> fromEvent evt of
      (Just obj) -> pure obj
      (Nothing) -> throwError "You are calling 'customEventHandlers_' CustomEvent in nonCustomEvent listener!"

  writeToHtml obj = do
    logM obj
    case obj.type_input of
      "record" -> renderRecord obj
      "array" -> renderArray obj
      _ -> throwError $ "Wrong 'type_input', fix your call to customEvent."

  renderRecord obj = do
    document_ <- document
    box <- document_ `query` obj.box
    template <- document_ `query` obj.template
    templateHTML <- liftEffect $ innerHTML template
    injectedHtml <- liftEffect $ sanitize $ placeholder templateHTML obj."data"
    liftEffect $ setInnerHTML injectedHtml box

  renderArray obj = do
    arr_ <- runExceptT $ readArray obj."data"
    let arr = fromRight [] arr_
    document_ <- document
    box <- document_ `query` obj.box
    template <- document_ `query` obj.template
    templateHTML <- liftEffect $ innerHTML template
    -- TODO make it possible to add wrapper as well. like <ul>li,li,li</ul>
    injectedHtml <- liftEffect $ sanitize $ joinWith "\n" $ placeholderArr templateHTML arr
    liftEffect $ setInnerHTML injectedHtml box
