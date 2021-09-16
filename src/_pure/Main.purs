module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Debug (traceM)
import Effect (Effect)
import Effect.Console (log)
import Placeholder (Template(..), templateInject)
import Web.DOM.Element (fromEventTarget, matches)
import Web.DOM.ParentNode (QuerySelector(..))
import Web.Event.Event (Event, target)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes (click)
import Web.HTML.HTMLDocument (toEventTarget)
import Web.HTML.Window (document)


isSelectorEvent :: Event -> String -> Effect Boolean
isSelectorEvent evt selector = do
  case (fromEventTarget =<< target evt) of
    Nothing -> pure false
    (Just elem) -> matches (QuerySelector selector) elem

clack :: Boolean -> Effect Unit
clack false = pure unit
clack true = log "clack"

cluck :: Boolean -> Effect Unit
cluck false = pure unit
cluck true = log "cluck"


fn :: Event -> Effect Unit
fn evt = do
  let isSelector = isSelectorEvent evt

  isSelector ".header-click" >>= clack
  isSelector ".click-me" >>= cluck


addEventListeners :: Effect Unit
addEventListeners = do
  fn_ <- eventListener fn
  document_ <- window >>= document

  -- Click event listener
  addEventListener click fn_ false (toEventTarget document_)


main :: Effect Unit
main = do
  addEventListeners

-- document.addEventListener('click', function (event) {
-- 	// Check for the .click-me class
-- 	// If the clicked element doesn't have it, do nothing
-- 	if (!event.target.matches('.click-me')) return;
-- 	// The code you want to run goes here...
-- });


  -- window
  --   >>= document >>= addEventListener (EventType "click") cb false


  log "works log"
  log $ templateInject (Test "<p>[[test]]</p>" {test: "hello", so: "oau"})
  log $ templateInject (Other "<p>[[other]]</p>" {other: "other txt", extra: "extra"})
