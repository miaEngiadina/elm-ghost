module Ghost.Log exposing
    ( bool
    , datetime
    , html
    , int
    , string
    )

import Html exposing (Html)
import Html.Parser
import Html.Parser.Util as Util
import Time


string : String -> Maybe String -> Html msg
string title content =
    Html.span []
        [ content
            |> Maybe.withDefault "null"
            |> (++) ": "
            |> (++) title
            |> Html.text
        , Html.br [] []
        ]


int : String -> Maybe Int -> Html msg
int title content =
    content
        |> Maybe.map String.fromInt
        |> string title


bool : String -> Maybe Bool -> Html msg
bool title content =
    case content of
        Just True ->
            string title (Just "True")

        Just False ->
            string title (Just "False")

        Nothing ->
            string title Nothing


datetime : String -> Maybe Time.Posix -> Html msg
datetime title content =
    string title <|
        case content of
            Just posixTime ->
                Just <|
                    (Time.toDay Time.utc posixTime |> String.fromInt)
                        ++ ". "

            Nothing ->
                Nothing


html : String -> Maybe (List Html.Parser.Node) -> Html msg
html title content =
    case content of
        Nothing ->
            string title Nothing

        Just code ->
            Html.span []
                [ Html.text title
                , code
                    |> Util.toVirtualDom
                    |> Html.span []
                , Html.br [] []
                ]
