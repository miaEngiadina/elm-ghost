module Ghost.Tag exposing (Tag, decoder, uid)

import Ghost.Misc as Misc exposing (try)
import Json.Decode exposing (Decoder, field, list, nullable, string, succeed)
import Json.Decode.Extra exposing (andMap)
import Json.Decode.Pipeline exposing (required)


type alias Tag =
    { id_ : Maybe String
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



{--
view : Tag -> Html msg
view tag =
    Html.div []
        [ Log.string "id" tag.id_
        , Log.string "name" tag.name
        , Log.string "slug" tag.slug
        , Log.string "description" tag.description
        , Log.string "feature_image" tag.feature_image
        , Log.string "visibility" tag.visibility
        , Log.string "meta_title" tag.meta.title
        , Log.string "meta_description" tag.meta.description
        , Log.string "url" tag.url
        , Html.hr [] []
        ]
--}
