module Models (..) where

import Time

import Constants


type alias AppModel =
  { mode : AppMode
  , periodType : PeriodType
  , lastTick : Time.Time -- Time of the last tick received
  , clock : Time.Time -- Time remaining on the tomato clock
  , clockMax : Time.Time -- Full duration of the tomato clock
  , nextSession : Time.Time -- Length of next session
  , nextBreak : Time.Time -- Length of next break
  , debug : Bool
  }


initialModel : AppModel
initialModel =
  { mode = Starting
  , periodType = Session
  , nextSession = Constants.initialSessionDuration
  , nextBreak = Constants.initialBreakDuration
  , debug = False
  , lastTick = 0 -- first Tick Action sets these up
  , clock = 0
  , clockMax = 0
  }


type AppMode
  = Starting -- initial state
  | Running -- clock moving
  | Pausing -- clock not moving


type PeriodType
  = Session -- Clock representing a work session
  | Break -- Clock representing a break session


-- Helper function to move to next session type
flipClock : AppModel -> AppModel
flipClock model =
  case model.periodType of
    Session ->
      { model
      | periodType= Break
      , clock = model.nextBreak
      , clockMax = model.nextBreak
      }

    Break ->
      { model
      | periodType = Session
      , clock = model.nextSession
      , clockMax = model.nextSession
      }


-- Helper function to format a Time as MM:SS
toLabel : Time.Time -> String
toLabel time =
  let
    allSeconds = round (time / Time.second)
    minutes = allSeconds // 60
    seconds = allSeconds % 60
  in
    toString minutes ++ ":" ++
      (if seconds < 10 then "0" else "") ++ toString seconds


-- Helper function to provide the label for the top of the tomato
showPeriodType : PeriodType -> String
showPeriodType c =
  case c of
    Session -> "Session"
    Break -> "Break"
