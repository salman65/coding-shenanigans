module Main exposing (Model, Msg(..), init, main, update, validationCheck, view, viewInput)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , pass : String
    , confirm_pass : String
    }


init : Model
init =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Pass String
    | ConfirmPass String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name newContent ->
            { model | name = newContent }

        Pass newContent ->
            { model | pass = newContent }

        ConfirmPass newContent ->
            { model | confirm_pass = newContent }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.pass Pass
        , viewInput "password" "Confirm Password" model.confirm_pass ConfirmPass
        , validationCheck model
        ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput field_type field_name field_value msg =
    input [ type_ field_type, placeholder field_name, value field_value, onInput msg ] []


validationCheck : Model -> Html Msg
validationCheck model =
    if model.pass == model.confirm_pass then
        div [ style "color" "green" ] [ text "Ok!" ]

    else
        div [ style "color" "red" ] [ text "Passwords do not match!" ]
