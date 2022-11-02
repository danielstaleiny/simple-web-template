module Pages.Index where

import Prelude

import AddEventListener as AddEventListener
import Config (environment)
import Effect (Effect)
import Effect.Aff (launchAff, launchAff_)
import EventListener.Click (click)
import Events.Utils (customEventHandlers_)
import Template.Events (customEventHandlers)
import Template.Utils as TemplateUtils
import Util.EventCatcher (matches)
import Util.HTML (addEventListener, ifThen)
import Web.Event.Event (Event)
import Web.Event.EventTarget (eventListener)
import Web.HTML.Event.EventTypes as EventType


-- Change how we call customEvent. What information we need to send are.
-- Type "template"
-- Array | Record
-- Template Box
-- Template Template
-- Data
--
-- This way we can use generic function in customEventHandler
--
-- We can also add DOM functions so you can call them in the monad
-- These could be more ergonomic than native methods, but we want to add same cabability,
-- This way we can test it and swap the Effect methods.
-- Test it out if we can call methods from capability.

main :: Effect Unit
main = do
  -- AddEventListener.click clickHandlers
  -- AddEventListener.custom customEventHandlers
  pure unit





  -- void <<< launchAff $ runApp program environment



-- template :: Foreign -> Aff Unit
-- template = Utils.renderRecord { box: "#box-error", template: "#template-error" }




-- customEventHandlers :: String -> Foreign -> Aff Unit
-- customEventHandlers "error" = Error.template
-- customEventHandlers "ui" = Ui.template
-- customEventHandlers "list" = List.template
-- customEventHandlers str = \_ -> liftEffect $ Log.error $ "CustomEventHandlerType not found among customEventHandlers! type='" <> str <> "'"

-- clickHandlers :: Event -> Effect Unit
-- clickHandlers evt = launchAff_ do
--   matches evt "[click='click']" >>= ifThen click

-- newtype Name = Name String

-- getName :: Name -> String
-- getName (Name s) = s

--                    -- Layer 3

-- -- Capability type classes:
-- class (Monad m) <= LogToScreen m where
--   log :: String -> m Unit


-- class (Monad m) <= GetValue m where
--   get :: m String

-- -- class (Monad m) <= GetUserName m where
-- --   getUserName :: m Name

-- -- Business logic that uses these capabilities
-- -- which makes it easier to test
-- --
-- program2 :: forall m. -- AppM
--           MonadAff m =>
--           MonadThrow String m =>
--           GetValue m =>
--           m Unit
-- program2 = do
--   liftEffect <<< Console.log $ "2 What is your name?"
--   name <- get
--   liftEffect <<< Console.log $ "2 You name is " <> name

-- program :: forall m. -- AppM
--           MonadAff m =>
--           MonadThrow String m =>
--           LogToScreen m =>
--           GetValue m =>
--           m Unit
-- program = do
--   log "What is your name?"
--   name <- get
--   log $ "You name is " <> name

-- -- Layer 2 (Production)
-- type Environment = { someValue :: Int }

-- newtype AppM a = AppM (ReaderT Environment (ExceptT String Aff) a)
-- derive newtype instance functorTestM    :: Functor AppM
-- derive newtype instance applyAppM       :: Apply AppM
-- derive newtype instance Applicative AppM
-- derive newtype instance bindAppM        :: Bind AppM
-- derive newtype instance monadAppM       :: Monad AppM
-- derive newtype instance monadEffectAppM     :: MonadEffect AppM
-- derive newtype instance monadAffAppM        :: MonadAff AppM
-- derive newtype instance monadErrorAppM :: MonadThrow String AppM

-- runApp :: forall a. AppM a -> Environment -> Aff Unit
-- runApp (AppM reader_T) env = do
--   res <- runExceptT $ runReaderT reader_T env
--   case res of
--     (Right _) -> do
--       pure unit
--     (Left err) -> do
--       -- TODO emit error with error event handler
--       liftEffect $ Console.log err
--       pure unit
-- -- Layer 1 (the implementations of each instance)
-- instance LogToScreen AppM where
--   log = liftEffect <<< Console.log

-- -- instance monadAskAppMA :: TypeEquals e Environment => MonadAsk e AppMA where
-- --   ask = AppMA $ asks from

-- instance GetValue AppM where
--   get = pure "Daniel"
--     -- throwError "hello"
--     -- ?h $ pure $ (Left "Hello" :: Either String String)


-- -- instance GetUserName AppM where
-- --   getUserName = liftEffect do
-- --     -- some effectful thing that produces a string
-- --     pure $ Name "some name"
