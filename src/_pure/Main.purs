module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Placeholder (Template(..), templateInject)



main :: Effect Unit
main = do
  log "works log"
  log $ templateInject (Test "<p>[[test]]</p>" {test: "hello", so: "oau"})
  log $ templateInject (Other "<p>[[other]]</p>" {other: "other txt", extra: "extra"})
