module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Task
import Time


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { zone : Time.Zone, time : Time.Posix }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0), Task.perform AdjustTimezone Time.here )



-- UPDATE


type Msg
    = AdjustTimezone Time.Zone
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AdjustTimezone zone ->
            ( { model | zone = zone }, Cmd.none )

        Tick time ->
            ( { model | time = time }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    h4 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
