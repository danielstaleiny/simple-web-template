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


isSelectorEvent :: Event -> Effect Boolean
isSelectorEvent evt = do
  case (fromEventTarget =<< target evt) of
    Nothing -> pure false
    (Just elem) -> matches (QuerySelector ".click-me") elem

fn :: Event -> Effect Unit
fn evt = do
  isClickMe <- isSelectorEvent evt
  case isClickMe of
    false -> pure unit
    true -> do
      log "clucken"



main :: Effect Unit
main = do
  fn_ <- eventListener fn
  document_ <- window >>= document
  addEventListener click fn_ false (toEventTarget document_)

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
