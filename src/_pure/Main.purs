module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
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


isSelectorEvent :: Event -> String -> Aff Boolean
isSelectorEvent evt selector = do
  case (fromEventTarget =<< target evt) of
    Nothing -> pure false
    (Just elem) -> liftEffect $ matches (QuerySelector selector) elem

ifThen :: Aff Unit -> Boolean  -> Aff Unit
ifThen _ false  = pure unit
ifThen f true  = f

clack :: Event -> Aff Unit
clack _ = liftEffect $ log "clack"

cluck :: Event -> Aff Unit
cluck _ = liftEffect $ log "cluck"


clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  let isSelector = isSelectorEvent evt

  isSelector "[click='clack']" >>= ifThen (clack evt)
  isSelector "[click='cluck']" >>= ifThen (cluck evt)


addEventListeners :: Effect Unit
addEventListeners = do
  clickEventListeners_ <- eventListener clickEventListeners
  document_ <- window >>= document

  -- Click event listener
  addEventListener click clickEventListeners_ false (toEventTarget document_)


main :: Effect Unit
main = do
  addEventListeners

  log "works log"
  log $ templateInject (Test "<p>[[test]]</p>" {test: "hello", so: "oau"})
  log $ templateInject (Other "<p>[[other]]</p>" {other: "other txt", extra: "extra"})
