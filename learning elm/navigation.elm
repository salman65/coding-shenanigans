module Main exposing (Model, Msg(..), init, main, subscriptions, update, view, viewLink)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing ((</>), Parser, map, oneOf, parse, s, string)


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { url : Maybe Route, key : Nav.Key }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model (parse parseRoute url) key, Cmd.none )


type Route
    = Initial String
    | Request String
    | NotFound


parseRoute : Parser (Route -> a) a
parseRoute =
    oneOf
        [ map Initial string
        , map Request (s "request" </> string)
        ]



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = parse parseRoute url }, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Url Navigation"
    , body =
        [ text "Current url is: "
        , b []
            [ case model.url of
                Nothing ->
                    text "Url parsing failed!"

                Just route ->
                    case route of
                        NotFound ->
                            text "Url not found!"

                        Initial val ->
                            text ("/" ++ val)

                        Request val ->
                            text ("/request/" ++ val)
            ]
        , ul []
            [ viewLink "/home"
            , viewLink "/docs"
            , viewLink "/request/haha"
            , viewLink "/request/lala"
            , viewLink "https://pay.google.com/about/static/images/social/knowledge_graph_logo.png"
            ]
        ]
    }


viewLink : String -> Html Msg
viewLink path =
    li []
        [ a [ href path ] [ text path ]
        ]
