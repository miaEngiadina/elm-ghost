module Ghost.Tag exposing (Tag, decoder, uid)

import Ghost.Misc as Misc exposing (try)
import Json.Decode exposing (Decoder, field, list, string, succeed)
import Json.Decode.Extra exposing (andMap)


type alias Tag =
    { id : Maybe String
    , name : Maybe String
    , slug : Maybe String
    , description : Maybe String
    , feature_image : Maybe String
    , visibility : Maybe String
    , meta : Misc.TID
    , url : Maybe String
    }


uid : String
uid =
    "tags"


decoder : Decoder (List Tag)
decoder =
    field uid (list decodeTag)


decodeTag : Decoder Tag
decodeTag =
    succeed Tag
        |> try "id" string
        |> try "name" string
        |> try "slug" string
        |> try "description" string
        |> try "feature_image" string
        |> try "visibility" string
        |> andMap (Misc.tidDecoder "meta")
        |> try "url" string
