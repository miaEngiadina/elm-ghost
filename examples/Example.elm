module Example exposing
    ( Model
    , Msg(..)
    , State(..)
    , init
    , main
    , subscriptions
    , update
    , view
    )

import Browser
import Ghost
import Ghost.Author
import Ghost.Post
import Ghost.Settings
import Ghost.Tag
import Html exposing (Html, pre, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type State
    = Loading
    | Failure String
    | Success


type alias Model =
    { ghost : Ghost.Config
    , rslt : Maybe (List Ghost.Post)
    , state : State
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model
        (Ghost.config
            "http://localhost:2368/"
            "2951c7676d21b0117451fc9a5e"
            "v2"
        )
        Nothing
        Loading
    , Cmd.none
    )


type Msg
    = Load
    | GotText (Result Ghost.Error (List Ghost.Post))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            ( model
            , Ghost.posts model.ghost GotText
            )

        GotText result ->
            case result of
                Ok fullText ->
                    ( { model
                        | state = Success
                        , rslt = Just fullText
                      }
                    , Cmd.none
                    )

                Err info ->
                    ( { model | state = Failure <| Ghost.errorToString info }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.button [ onClick Load ] [ Html.text "load" ]
        , case model.state of
            Failure info ->
                text info

            Loading ->
                text "Loading..."

            Success ->
                case model.rslt of
                    Just list ->
                        Html.div []
                            [ list
                                |> List.map Ghost.Post.view
                                |> Html.div []

                            --, Ghost.Meta.view meta
                            ]

                    _ ->
                        Html.text "nothing"
        ]
