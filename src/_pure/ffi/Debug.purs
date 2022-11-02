module Debug where

import Effect (Effect)
import Foreign (Foreign)
import Prelude (Unit)


foreign import logM :: Foreign -> Effect Unit
