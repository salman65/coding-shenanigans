module Main exposing (Model(..), Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (Html, pre, text)
import Http


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- MODEL


type Model
    = Success String
    | Error
    | Loading


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "https://elm-lang.org/assets/public-opinion.txt"
        , expect = Http.expectString GotText
        }
    )



-- UPDATE


type Msg
    = GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText result ->
            case result of
                Ok data ->
                    ( Success data, Cmd.none )

                Err _ ->
                    ( Error, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Success data ->
            pre [] [ text data ]

        Error ->
            text "Error..."

        Loading ->
            text "Loading..."
