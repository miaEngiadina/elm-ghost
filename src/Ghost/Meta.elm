module Ghost.Meta exposing (Meta, decoder, empty, uid, view)

import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx


type alias Meta =
    { page : Int
    , limit : Int
    , pages : Int
    , total : Int
    , next : Maybe Int
    , vrev : Maybe Int
    }


empty : Meta
empty =
    Meta 0 0 0 0 Nothing Nothing


uid : String
uid =
    "meta"


decoder : JD.Decoder x -> JD.Decoder ( x, Meta )
decoder prev =
    prev |> JD.map Tuple.pair |> JDx.andMap (JD.field uid (JD.field "pagination" toMeta))


toMeta : JD.Decoder Meta
toMeta =
    JD.map6 Meta
        (JD.field "page" JD.int)
        (JD.field "limit" JD.int)
        (JD.field "pages" JD.int)
        (JD.field "total" JD.int)
        (JD.field "next" (JD.maybe JD.int))
        (JD.field "prev" (JD.maybe JD.int))


view : Meta -> Html msg
view meta =
    Html.div []
        [ meta.page
            |> String.fromInt
            |> (++) "page: "
            |> Html.text
        , meta.limit
            |> String.fromInt
            |> (++) " -- limit: "
            |> Html.text
        , meta.pages
            |> String.fromInt
            |> (++) " -- pages: "
            |> Html.text
        , meta.total
            |> String.fromInt
            |> (++) " -- total: "
            |> Html.text
        ]
