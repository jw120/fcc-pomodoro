module Actions (..) where

import Models
import Time


type Action
  = NoOp
  | Tick Time.Time -- triggered by recurring signal
  | TogglePause -- trigger when mouse clicked on the tomato
  | ChangeNextDuration Models.PeriodType Time.Time -- triggered by clicks on the widget buttons
  | ToggleDebug -- triggered by pressing 'd'
