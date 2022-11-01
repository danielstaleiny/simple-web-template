module Main where

import Prelude

import Config (environment)
import Control.Monad.Error.Class (class MonadThrow, throwError)
import Control.Monad.Except (ExceptT, runExceptT)
import Control.Monad.Reader (ReaderT, runReaderT)
import Control.Plus (empty)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, error, launchAff, never)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Console as Console
import Events.AddEventListeners (addEventListeners)




-- (<*>) apply  :: f (a -> b) -> f a -> f b
-- (<$>) map  :: (a -> b) -> f a -> f b
-- (>>=) bind  :: m a -> (a -> m b) -> m b
-- (>=>) kleisly arrow  :: (a -> m b) -> (b -> m c) -> a -> m c



main :: Effect Unit
main = do
  -- log "PS Main loaded"
  -- TODO this should
  -- Needs class capability for each page, hase its own list of the event handler.
  -- Each event handler runs our custom Monad stack
  -- Each page defines UI capability class which defines methods available in that view,
  -- this UI class is then passed to each eventhandler custom runApp method.
  -- This way we separate load and separate logic for each page but re-use most of the code on each page.
  -- Resould to be expect is lower js output on each page.
  -- Preferably all the utilities should be its own module to be able to re-use the utils.


  addEventListeners
  void <<< launchAff $ runApp program environment
  void <<< launchAff $ runApp program2 environment
  pure unit

newtype Name = Name String

getName :: Name -> String
getName (Name s) = s

                   -- Layer 3

-- Capability type classes:
class (Monad m) <= LogToScreen m where
  log :: String -> m Unit


class (Monad m) <= GetValue m where
  get :: m String

-- class (Monad m) <= GetUserName m where
--   getUserName :: m Name

-- Business logic that uses these capabilities
-- which makes it easier to test
--
program2 :: forall m. -- AppM
          MonadAff m =>
          MonadThrow String m =>
          GetValue m =>
          m Unit
program2 = do
  liftEffect <<< Console.log $ "2 What is your name?"
  name <- get
  liftEffect <<< Console.log $ "2 You name is " <> name

program :: forall m. -- AppM
          MonadAff m =>
          MonadThrow String m =>
          LogToScreen m =>
          GetValue m =>
          m Unit
program = do
  log "What is your name?"
  name <- get
  log $ "You name is " <> name

-- Layer 2 (Production)
type Environment = { someValue :: Int }

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
      -- TODO emit error with error event handler
      liftEffect $ Console.log err
      pure unit
-- Layer 1 (the implementations of each instance)
instance LogToScreen AppM where
  log = liftEffect <<< Console.log

-- instance monadAskAppMA :: TypeEquals e Environment => MonadAsk e AppMA where
--   ask = AppMA $ asks from

instance GetValue AppM where
  get = pure "Daniel"
    -- throwError "hello"
    -- ?h $ pure $ (Left "Hello" :: Either String String)


-- instance GetUserName AppM where
--   getUserName = liftEffect do
--     -- some effectful thing that produces a string
--     pure $ Name "some name"









