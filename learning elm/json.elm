module Main exposing (Model(..), Msg(..), getRandomGif, gifDecoder, init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type Model
    = Success String
    | Error
    | Loading


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomGif )



-- UPDATE


type Msg
    = GotGif (Result Http.Error String)
    | GenerateMore


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotGif result ->
            case result of
                Ok data ->
                    ( Success data, Cmd.none )

                Err _ ->
                    ( Error, Cmd.none )

        GenerateMore ->
            ( Loading, getRandomGif )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Success data ->
            div []
                [ h2 [] [ text "Random cat gifs:- " ]
                , img [ src data, style "display" "block", style "padding-bottom" "10px" ] []
                , button [ onClick GenerateMore ] [ text "Generate More" ]
                ]

        Error ->
            div []
                [ h2 [] [ text "Failed to get gif!" ]
                , button [ onClick GenerateMore ] [ text "Try again" ]
                ]

        Loading ->
            text "Loading..."


getRandomGif : Cmd Msg
getRandomGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }


gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)
