module EventCatcher where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Web.DOM.Element (Element)
import Web.DOM.Element as E
import Web.DOM.ParentNode (QuerySelector(..))
import Web.Event.Event (Event, target)


type EventObj = { event :: Event, element :: Element }

isSelectorEvent :: Event -> String -> Aff Boolean
isSelectorEvent evt q = do
  case (E.fromEventTarget =<< target evt) of
    Nothing -> pure false
    (Just elem) -> liftEffect $ E.matches (QuerySelector q) elem

matches :: Event -> String -> Aff (Maybe EventObj)
matches event q = do
  case (E.fromEventTarget =<< target event) of
    Nothing -> pure Nothing
    (Just element) -> do
      match <- liftEffect $ E.matches (QuerySelector q) element
      if match
      then
         pure $ Just {event, element}
      else
         pure Nothing

closest :: Event -> String -> Aff (Maybe EventObj)
closest event q = do
  case (E.fromEventTarget =<< target event) of
    Nothing -> pure Nothing
    (Just targetElement) -> do
      maybeElem <- liftEffect $ E.closest (QuerySelector q) targetElement
      case maybeElem of
        Nothing -> pure Nothing
        (Just element) -> pure $ Just {event, element}
