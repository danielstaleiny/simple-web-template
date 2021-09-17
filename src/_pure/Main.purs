module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import EventListeners (addEventListeners)


main :: Effect Unit
main = do
  log "works log"
  addEventListeners
