module Main where

import Prelude

import Config (Environment, environment)
import Control.Monad.Except.Trans (class MonadThrow)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Aff.Class (class MonadAff, liftAff)
import Framework (class DebugFunctions, class QueryHtml, AppM(..), customEvent, customEventListeners, log, runApp)
import Template.Utils as TemplateUtils
import Util.EventCatcher (matches)
import Util.HTML (addEventListener, ifThen)
import Web.DOM (Element)
import Web.Event.Event (Event)
import Web.Event.EventTarget (eventListener)
import Web.HTML.Event.EventTypes as EventType

-- (<*>) apply  :: f (a -> b) -> f a -> f b
-- (<$>) map  :: (a -> b) -> f a -> f b
-- (>>=) bind  :: m a -> (a -> m b) -> m b
-- (>=>) kleisly arrow  :: (a -> m b) -> (b -> m c) -> a -> m c

clickEventListeners :: Event -> Effect Unit
clickEventListeners evt = launchAff_ do
  let matches_ q = matches evt q
  let appM fn ev = runApp (fn ev) environment
  let ifThen_ predicate fn = predicate >>= ifThen (appM fn)
  -- Cancelable events. We run new AppM for each event.
  -- This way One event cannot cancel other events.
  matches_ "[click='click']" `ifThen_` click

main :: Effect Unit
main = addEventListeners
  -- Needs class capability for each page, hase its own list of the event handler.
  -- Each event handler runs our custom Monad stack
  -- Each page defines UI capability class which defines methods available in that view,
  -- this UI class is then passed to each eventhandler custom runApp method.
  -- This way we separate load and separate logic for each page but re-use most of the code on each page.
  -- Resould to be expect is lower js output on each page.
  -- Preferably all the utilities should be its own module to be able to re-use the utils.

addEventListeners :: Effect Unit
addEventListeners = do
  -- Click event listeners
  addEventListener EventType.click =<< eventListener clickEventListeners
  -- Custom event listeners
  addEventListener TemplateUtils.customEventType =<< eventListener customEventListeners

class (Monad m) <= TemplateIndex m where
  ui :: { name :: String } -> m Unit
  list :: Array { name :: String } -> m Unit

instance TemplateIndex AppM where
  ui obj = liftAff $ customEvent {type_input: "record", box: "#box-click", template: "#template-click", type_: "template"} obj
  list obj = liftAff $ customEvent {type_input: "array", box: "#box-list", template: "#template-list", type_: "template"} obj



  -- TODO take care of case when template is inside a box.
  -- Make warning about it.

click ::  forall m. -- AppM
          MonadAff m =>
          MonadThrow String m =>
          DebugFunctions m =>
          QueryHtml m =>
          TemplateIndex m =>
          {event :: Event, element :: Element }
          -> m Unit
click _ = do
  log "Click"
  -- HTML.error {name: "ERROROR UI"}
  ui { name: "UI" }
  list [{name: "List UI"}, {name: "eyoo"}]


