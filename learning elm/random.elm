module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { dieFace : Int }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1, Cmd.none )



-- UPDATE


type Msg
    = GenerateRandom
    | NewVal Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateRandom ->
            ( model, Random.generate NewVal (Random.int 1 6) )

        NewVal val ->
            ( Model val, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick GenerateRandom ] [ text "Randomize.." ]
        ]
