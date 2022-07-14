module IfThen where

import Prelude

ifThen :: forall m. Applicative m => m Unit -> Boolean  -> m Unit
ifThen _ false  = pure unit
ifThen f true  = f
