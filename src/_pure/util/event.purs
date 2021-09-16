module Event where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Web.DOM.Element (fromEventTarget, matches)
import Web.DOM.ParentNode (QuerySelector(..))
import Web.Event.Event (Event, target)


isSelectorEvent :: Event -> String -> Aff Boolean
isSelectorEvent evt selector = do
  case (fromEventTarget =<< target evt) of
    Nothing -> pure false
    (Just elem) -> liftEffect $ matches (QuerySelector selector) elem
