module CustomEventType where

import Web.Event.Event (EventType(..))

update :: EventType
update = EventType "update-custom"

error :: EventType
error = EventType "error-custom"


custom :: EventType
custom = EventType "custom-event"
