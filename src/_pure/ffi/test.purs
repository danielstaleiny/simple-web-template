module Test where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Web.Event.EventTarget (EventTarget)

  
foreign import fetchHtmlAndRender :: String -> Effect Unit

                                     
foreign import loadPage :: Effect Unit

                           
foreign import windowTarget :: Effect EventTarget
