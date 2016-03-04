module Constants (..) where

import Time


-- Initial duration for a session
initialSessionDuration: Time.Time
initialSessionDuration = 30 * Time.second

-- Initial duration for a break
initialBreakDuration : Time.Time
initialBreakDuration = 5 * Time.second

-- Change in duration from clicking widget buttons
widgetIncrement : Time.Time
widgetIncrement = 5 * Time.second

-- Update frequency
tickRate : Time.Time
tickRate = 100 * Time.millisecond
