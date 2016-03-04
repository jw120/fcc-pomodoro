module Update (..) where

import Models exposing (AppModel, AppMode(..), PeriodType(..))
import Actions exposing (Action(..))


update : Action -> AppModel -> AppModel
update action model =
  case action of
    NoOp ->
      model

    Tick time ->
      let
        model' = { model | lastTick = time }
      in
        case model.mode of
          Running ->
            let
              newclock = model.clock - (time - model.lastTick)
            in
              if newclock > 0 then -- if timer has not run out
                { model' | clock = newclock }
              else -- if timer has run out switch to next period
                Models.flipClock model'

          Pausing -> -- If clock is paused, just update lastTick
            model'

          Starting -> -- First tick after app starts initialises the clock (paused)
            { model'
            | mode = Pausing
            , periodType = Session
            , clock = model.nextSession
            , clockMax = model.nextSession
            }

    TogglePause ->
      case model.mode of
        Running -> { model | mode = Pausing }
        Pausing -> { model | mode = Running }
        Starting -> model


    ChangeNextDuration targetType delta -> -- adjust nextBreak/nextSession
      if targetType == model.periodType then -- user trying to adjust to the current period type
        case model.mode of
          Running -> -- Don't allow changes to active clock while it is running
            model

          Starting -> -- Should not happen
            model

          Pausing -> -- Changing the active period type: changes clock max and preserve clock time used
            case targetType of
              Session ->
                let
                  nextSession' = max 0 (model.nextSession + delta)
                  clockUsed = model.clockMax - model.clock
                in
                  { model
                  | nextSession = nextSession'
                  , clockMax = nextSession'
                  , clock = max 0  (nextSession' - clockUsed)
                  }
              Break ->
                let
                  nextBreak' = max 0 (model.nextBreak + delta)
                  clockUsed = model.clockMax - model.clock
                in
                  { model
                  | nextBreak = nextBreak'
                  , clockMax = nextBreak'
                  , clock = max 0 (nextBreak' - clockUsed)
                  }
      else -- user changing the inactive period type, just changes the next timer start point
        case targetType of
          Session ->
            { model
            | nextSession = max 0 (model.nextSession + delta)
            }

          Break ->
            { model
            | nextBreak = max 0 (model.nextBreak + delta)
            }


    ToggleDebug ->
      { model
      | debug = not model.debug
      }
