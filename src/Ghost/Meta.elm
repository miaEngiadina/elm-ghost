module Ghost.Meta exposing (Meta, decoder, empty, uid)

import Json.Decode exposing (Decoder, field, int, map, map6, maybe)
import Json.Decode.Extra exposing (andMap)


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


decoder : Decoder x -> Decoder ( x, Meta )
decoder prev =
    prev
        |> map Tuple.pair
        |> andMap (field uid (field "pagination" toMeta))


toMeta : Decoder Meta
toMeta =
    map6 Meta
        (field "page" int)
        (field "limit" int)
        (field "pages" int)
        (field "total" int)
        (field "next" (maybe int))
        (field "prev" (maybe int))
