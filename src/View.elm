module View (..) where

import Html exposing (button, div, span)
import Html.Attributes as HA
import Html.Events as HE
import Svg exposing (svg, circle, clipPath, defs, rect)
import Svg.Attributes as SA
import Time

import Actions
import Constants
import Models


-- Top level view function
view : Signal.Address Actions.Action -> Models.AppModel -> Html.Html
view address model =
  div
    []
    [ div
      [ HA.class "page" ]
      [ div [ HA.class "title"] [ Html.text "FreeCodeCamp" ]
      , controlsBar address model
      , div [ HA.class "tomato-container" ] [ tomato address model]
      ]
    , if model.debug then
        div [ HA.class "debug" ] [ Html.text (toString model)]
      else
        div [] []
    ]


-- controls-bar includes the two controls for Break and Session lengths
controlsBar : Signal.Address Actions.Action -> Models.AppModel -> Html.Html
controlsBar address model =
  div
    [ HA.class "controls-bar" ]
    [ control address "BREAK LENGTH" Models.Break model.nextBreak
    , control address "SESSION LENGTH" Models.Session model.nextSession
    ]


-- Each control for the lengths has a label, a time value and two buttons
control : Signal.Address Actions.Action -> String -> Models.PeriodType ->  Time.Time -> Html.Html
control address label periodType time =
  div
    [ HA.class "control"]
    [ div [ HA.class "control-label "] [ Html.text label ]
    , div
      [ HA.class "control-widget"]
      [ button
        [ HA.class "widget-button", HE.onClick address (Actions.ChangeNextDuration periodType (-Constants.widgetIncrement)) ]
        [ span [ HA.class "fa fa-minus-circle fa-lg" ] [] ]
      , Html.text (Models.toLabel time)
      , button
        [ HA.class "widget-button", HE.onClick address  (Actions.ChangeNextDuration periodType Constants.widgetIncrement) ]
        [ span [ HA.class "fa fa-plus-circle fa-lg" ] [] ]
      ]
    ]


-- Tomato visualization to show the timer
tomato : Signal.Address Actions.Action -> Models.AppModel -> Html.Html
tomato address model =
  let
    tomatoFraction = if model.clockMax == 0 then 0 else 1 - model.clock / model.clockMax
    clipX = 0
    clipY = 200 - 180 * tomatoFraction
    clipWidth = 220
    clipHeight = 180 * tomatoFraction
  in
    div
      [ HE.onClick address Actions.TogglePause ]
      [ svg
        [ SA.width "220", SA.height "220" ]
        [ circle
          [ SA.class "tomato-outer-circle", SA.cx "110", SA.cy "110", SA.r "100" ]
          []
        , defs
            []
            [ clipPath
              [ SA.id "tomato-inner-circle-clip" ]
              [ rect
                [ SA.x (toString clipX)
                , SA.y (toString clipY)
                , SA.width (toString clipWidth)
                , SA.height (toString clipHeight)
                ]
                []
              ]
            ]
        , circle
          [ SA.class ("tomato-inner-circle-" ++ Models.showPeriodType model.periodType)
          , SA.clipPath "url(#tomato-inner-circle-clip)"
          , SA.cx "110", SA.cy "110", SA.r "90"
          ]
          []
        , Svg.text'
          [ SA.class "tomato-label", SA.x "110", SA.y "60", SA.textAnchor "middle" ]
          [ Svg.text (Models.showPeriodType model.periodType)]
        , Svg.text'
          [ SA.class "tomato-timer", SA.x "110", SA.y "160", SA.textAnchor "middle" ]
          [ Svg.text (Models.toLabel model.clock) ]
        ]
      ]
