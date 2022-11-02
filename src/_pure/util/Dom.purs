module Util.HTML where

import Prelude

import Config (Environment)
import Data.Maybe (Maybe, maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Util.EventCatcher (EventObj)
import Web.Event.Event (EventType)
import Web.Event.EventTarget (EventListener)
import Web.Event.EventTarget as EventTarget
import Web.HTML (window)
import Web.HTML.HTMLDocument (toEventTarget)
import Web.HTML.Window (document)

addEventListener :: EventType -> EventListener -> Effect Unit
addEventListener type_ listener = EventTarget.addEventListener type_ listener false =<< (window >>= document <#> toEventTarget)

ifThen :: (EventObj -> Aff Unit) -> Maybe EventObj -> Aff Unit
ifThen fn maybeObj = maybe stopExecution fn maybeObj
  where
    stopExecution = pure unit

-- ifThen :: (forall a. AppM a -> Environment -> Aff Unit) -> Environment -> (EventObj -> Aff Unit) -> Maybe EventObj -> Aff Unit
-- ifThen runT environment fn maybeObj = maybe stopExecution runFn maybeObj
--   where
--     stopExecution = pure unit
--     runFn obj = runT (fn obj) environment
