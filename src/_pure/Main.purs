module Main where

import Prelude

import Control.Monad.Maybe.Trans (MaybeT(..), runMaybeT)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import EventListeners (addEventListeners)


main :: Effect Unit
main = do
  log "PS Main loaded"
  addEventListeners

  result <- runMaybeT do
    name <- MaybeT getName
    age <- MaybeT getAge
    pure { name, age }
  case result of
    Nothing -> log "Didn't work"
    Just rec -> do
      log $ "Got name: " <> rec.name <> " and age " <> show rec.age


getName :: Effect (Maybe String)
getName = pure $ Just "name"
getAge :: Effect (Maybe Int)
getAge = pure $ Just 1

-- main :: Effect Unit
-- main = do
