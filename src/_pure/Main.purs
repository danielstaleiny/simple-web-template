module Main where

import Prelude

import Config (Environment, environment)
import Control.Monad.Error.Class (class MonadThrow, throwError)
import Control.Monad.Except (ExceptT, runExceptT)
import Control.Monad.Except.Trans (runExceptT)
import Control.Monad.Reader (ReaderT, runReaderT)
import Control.Plus (empty)
import Data.Either (Either(..))
import Data.Either (fromRight)
import Data.Maybe (Maybe(..))
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Debug as Debug
import Dompurify (sanitize)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff (Aff)
import Effect.Aff (Aff, error, launchAff, never)
import Effect.Aff (launchAff_)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class (liftEffect)
import Effect.Class (liftEffect)
import Effect.Console as Console
import Effect.Console as Console
import Foreign (Foreign)
import Foreign (Foreign, unsafeFromForeign, unsafeToForeign, readArray)
import HtmlExtra (innerHTML, setInnerHTML)
import Placeholder (placeholder, placeholderArr)
import Template.Render as HTML
import Template.Utils as TemplateUtils
import Template.Utils as Utils
import Util.EventCatcher (matches)
import Util.HTML (addEventListener, ifThen)
import Util.HTML as Util.HTML
import Web.DOM (Element, ParentNode)
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.Event.CustomEvent (CustomEvent, detail, fromEvent, newWithOptions, toEvent)
import Web.Event.CustomEvent (newWithOptions)
import Web.Event.Event (Event)
import Web.Event.Event (Event)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (dispatchEvent)
import Web.Event.EventTarget (eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes as EventType
import Web.HTML.HTMLDocument (toEventTarget, toParentNode)
import Web.HTML.Window as Window

-- (<*>) apply  :: f (a -> b) -> f a -> f b
-- (<$>) map  :: (a -> b) -> f a -> f b
-- (>>=) bind  :: m a -> (a -> m b) -> m b
-- (>=>) kleisly arrow  :: (a -> m b) -> (b -> m c) -> a -> m c




  -- TODO take care of case when template is inside a box.
  -- Make warning about it.

click ::  forall m. -- AppM
          MonadAff m =>
          MonadThrow String m =>
          DebugFunctions m =>
          QueryHtml m =>
          TemplateIndex m =>
          {event :: Event, element :: Element }
          -> m Unit
click _ = do
  log "Click"
  -- HTML.error {name: "ERROROR UI"}
  ui { name: "UI" }
  list [{name: "List UI"}, {name: "eyoo"}]


clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  let matches_ q = matches evt q
  let appM fn ev = runApp (fn ev) environment
  let ifThen_ predicate fn = predicate >>= ifThen (appM fn)
  -- Cancelable events. We run new AppM for each event.
  -- This way One event cannot cancel other events.
  matches_ "[click='click']" `ifThen_` click

-- TODO G
getCustomEventType :: CustomEvent -> CustomData
getCustomEventType = unsafeFromForeign <<< detail

-- TODO G
renderUI ::  forall m. -- AppM
          MonadAff m =>
          MonadThrow String m =>
          WriteToHtml m =>
          Event ->
          m Unit
renderUI evt = do
  obj <- getCustomEventObject evt
  writeToHtml obj

-- TODO G
customEventListeners :: Event -> Effect Unit
customEventListeners ev = launchAff_ do
  -- Use 'custom-event' for all the event on the site
  -- Instead of creating different custom-event, use type_ to do different logic
  -- Similiar how we did it in Click events.
  runApp (renderUI ev) environment

addEventListeners :: Effect Unit
addEventListeners = do
  -- Click event listeners
  addEventListener EventType.click =<< eventListener clickEventListeners
  -- Custom event listeners
  addEventListener TemplateUtils.customEventType =<< eventListener customEventListeners

main :: Effect Unit
main = addEventListeners
  -- Needs class capability for each page, hase its own list of the event handler.
  -- Each event handler runs our custom Monad stack
  -- Each page defines UI capability class which defines methods available in that view,
  -- this UI class is then passed to each eventhandler custom runApp method.
  -- This way we separate load and separate logic for each page but re-use most of the code on each page.
  -- Resould to be expect is lower js output on each page.
  -- Preferably all the utilities should be its own module to be able to re-use the utils.
  --

-- Capability type classes:
-- TODO G
class (Monad m) <= DebugFunctions m where
  log :: String -> m Unit
  logM :: forall a. a -> m Unit

-- TODO G
class (Monad m) <= QueryHtml m where
  query :: ParentNode -> String -> m Element
  document :: m ParentNode

-- TODO G
class (Monad m) <= WriteToHtml m where
  getCustomEventObject :: Event -> m CustomData
  writeToHtml :: CustomData -> m Unit
  renderRecord :: CustomData -> m Unit
  renderArray :: CustomData -> m Unit






class (Monad m) <= TemplateIndex m where
  ui :: { name :: String } -> m Unit
  list :: Array { name :: String } -> m Unit


-- Layer 2 (Production)

-- TODO G
newtype AppM a = AppM (ReaderT Environment (ExceptT String Aff) a)
derive newtype instance functorTestM    :: Functor AppM
derive newtype instance applyAppM       :: Apply AppM
derive newtype instance Applicative AppM
derive newtype instance bindAppM        :: Bind AppM
derive newtype instance monadAppM       :: Monad AppM
derive newtype instance monadEffectAppM     :: MonadEffect AppM
derive newtype instance monadAffAppM        :: MonadAff AppM
derive newtype instance monadErrorAppM :: MonadThrow String AppM

-- TODO G
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

-- TODO G
instance DebugFunctions AppM where
  log = liftEffect <<< Console.log
  logM = liftEffect <<< Debug.logM <<< unsafeToForeign

-- instance monadAskAppMA :: TypeEquals e Environment => MonadAsk e AppMA where
--   ask = AppMA $ asks from

-- TODO G
buildCustomData :: {type_ :: String, type_input :: String, box :: String, template :: String} -> Foreign -> CustomData
buildCustomData { type_, type_input, box, template } data_ = { "type_": type_, "type_input": type_input, "box": box, template: template, "data": data_ }

-- TODO G
customEventType :: EventType
customEventType = EventType "custom-event"

-- TODO G
type CustomData = { type_ :: String, type_input ::String, box :: String, template :: String, "data" :: Foreign }
dispatchCustom :: CustomData -> Aff Unit
dispatchCustom obj =  do
  event <- liftEffect $ newWithOptions customEventType {bubbles: false, cancelable: false, composed: false, detail: Just obj}
  target <- liftEffect $ window >>= Window.document <#> toEventTarget
  _ <- liftEffect $ dispatchEvent (toEvent event) target
  pure unit

-- TODO G
customEvent :: forall a. {type_ :: String, type_input :: String, box :: String, template :: String} -> a -> Aff Unit
customEvent obj = dispatchCustom <<< buildCustomData obj <<< unsafeToForeign


-- TODO G
instance QueryHtml AppM where
  query target q = do
    mElem <- liftEffect $ querySelector (QuerySelector q) target
    case mElem of
      (Just elem) -> pure elem
      (Nothing) -> throwError $ "'" <> q <> "' Element was not found by querySelector"

  document = liftEffect $ window >>= Window.document >>= toParentNode >>> pure


-- TODO G
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


instance TemplateIndex AppM where
  ui obj = liftAff $ customEvent {type_input: "record", box: "#box-click", template: "#template-click", type_: "template"} obj
  list obj = liftAff $ customEvent {type_input: "array", box: "#box-list", template: "#template-list", type_: "template"} obj

    -- throwError "hello"
    -- ?h $ pure $ (Left "Hello" :: Either String String)
