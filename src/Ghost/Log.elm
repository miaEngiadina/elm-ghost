module Ghost.Log exposing
    ( bool
    , bool_null
    , datetime
    , html
    , int
    , int_null
    , string
    , string_null
    )

import Html exposing (Html)
import Html.Parser
import Html.Parser.Util as Util
import Time


string : String -> String -> Html msg
string title content =
    Html.span []
        [ content
            |> (++) ": "
            |> (++) title
            |> Html.text
        , Html.br [] []
        ]


string_null : String -> Maybe String -> Html msg
string_null title content =
    content
        |> Maybe.withDefault "null"
        |> string title


int : String -> Int -> Html msg
int title content =
    content
        |> String.fromInt
        |> string title


int_null : String -> Maybe Int -> Html msg
int_null title content =
    content
        |> Maybe.map String.fromInt
        |> string_null title


bool : String -> Bool -> Html msg
bool title content =
    string title <|
        if content == True then
            "True"

        else
            "False"


bool_null : String -> Maybe Bool -> Html msg
bool_null title content =
    case content of
        Just b ->
            bool title b

        Nothing ->
            string_null title Nothing


datetime : String -> Time.Posix -> Html msg
datetime title content =
    (Time.toDay Time.utc content |> String.fromInt)
        ++ ". "
        |> string title


html : String -> List Html.Parser.Node -> Html msg
html title content =
    Html.span []
        [ Html.text title
        , content
            |> Util.toVirtualDom
            |> Html.span []
        , Html.br [] []
        ]
