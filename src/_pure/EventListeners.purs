module EventListeners where

import Prelude

import Clack (clack)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Event (isSelectorEvent)
import Hack (hack)
import IfThen (ifThen)
import Web.Event.Event (Event)
import Web.Event.EventTarget (addEventListener, eventListener)
import Web.HTML (window)
import Web.HTML.Event.EventTypes (click)
import Web.HTML.HTMLDocument (toEventTarget)
import Web.HTML.Window (document)


cluck :: Event -> Aff Unit
cluck _ = liftEffect $ log "cluck"


clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  let isSelector = isSelectorEvent evt

  isSelector "[click='clack']" >>= ifThen (clack evt)
  isSelector "[click='cluck']" >>= ifThen (cluck evt)
  isSelector "[click='hack']" >>= ifThen (hack evt)


addEventListeners :: Effect Unit
addEventListeners = do
  clickEventListeners_ <- eventListener clickEventListeners
  document_ <- window >>= document

  -- Click event listener
  addEventListener click clickEventListeners_ false (toEventTarget document_)
