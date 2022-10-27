module EventListener.Click where

import Prelude

import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Template.Render as HTML
import Web.DOM (Element)
import Web.Event.Event (Event)

click :: {event :: Event, element :: Element } -> Aff Unit
click _ = do
  HTML.error {name: "ERROROR UI"}
  HTML.ui {name: "UI" }
  HTML.list [{name: "List UI"}, {name: "eyoo"}]
  liftEffect $ log "click"
