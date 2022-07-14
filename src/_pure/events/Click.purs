module EventListener.Click where

import Prelude

import CustomEvent as UI
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Web.DOM (Element)
import Web.Event.Event (Event)

click :: {event :: Event, element :: Element } -> Aff Unit
click _ = do
  UI.ui {name: "UI"}
  UI.error {name: "ERROROR UI"}
  liftEffect $ log "click"
