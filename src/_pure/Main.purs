module Main where

import Prelude

import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff)
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
  addEventListeners
  void <<< launchAff $ runApp program
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
program :: forall m. -- AppM
          MonadAff m =>
          LogToScreen m =>
          GetValue m =>
          m Unit
program = do
  log "What is your name?"
  name <- get
  log $ "You name is " <> name 

-- Layer 2 (Production)

newtype AppM a = AppM (MaybeT Aff a)
derive newtype instance functorTestM    :: Functor AppM
derive newtype instance applyAppM       :: Apply AppM
derive newtype instance Applicative AppM
derive newtype instance bindAppM        :: Bind AppM
derive newtype instance monadAppM       :: Monad AppM
derive newtype instance monadEffectAppM     :: MonadEffect AppM
derive newtype instance monadAffAppM        :: MonadAff AppM

runApp :: forall a. AppM a -> Aff (Maybe a)
runApp (AppM maybe_T) = runMaybeT maybe_T

-- Layer 1 (the implementations of each instance)
instance LogToScreen AppM where
  log = liftEffect <<< Console.log

instance GetValue AppM where
  get = AppM (MaybeT (pure Nothing))

-- instance GetUserName AppM where
--   getUserName = liftEffect do
--     -- some effectful thing that produces a string
--     pure $ Name "some name"









