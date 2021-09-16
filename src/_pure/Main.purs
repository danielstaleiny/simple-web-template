module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import EventListeners (addEventListeners)

main :: Effect Unit
main = do
  log "works log"
  addEventListeners

-- // const el = template.content.firstElementChild.cloneNode(true)
-- // el.innerHTML = placeholders(el.innerHTML, data)
-- // container.appendChild(el)

  -- log $ templateInject (Test "<p>[[test]]</p>" {test: "hello", so: "oau"})
  -- log $ templateInject (Other "<p>[[other]]</p>" {other: "other txt", extra: "extra"})
