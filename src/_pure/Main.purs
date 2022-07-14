module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import AddEventListeners (addEventListeners)

-- (<*>) apply  :: f (a -> b) -> f a -> f b
-- (<$>) map  :: (a -> b) -> f a -> f b
-- (>>=) bind  :: m a -> (a -> m b) -> m b
-- (>=>) kleisly arrow  :: (a -> m b) -> (b -> m c) -> a -> m c

main :: Effect Unit
main = do
  log "PS Main loaded"
  addEventListeners
