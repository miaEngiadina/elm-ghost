module Ghost.Tags exposing (Tag, decoder, get, view)

import Ghost.Log as Log
import Ghost.Misc as Misc
import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx


type alias Tag =
    { id_ : String
    , name : String
    , slug : Maybe String
    , description : Maybe String
    , feature_image : Maybe String
    , visibility : String
    , meta : Misc.TID
    , url : String
    }


get : String
get =
    "tags"


decoder : JD.Decoder (List Tag)
decoder =
    JD.field get (JD.list decodeTag)


decodeTag : JD.Decoder Tag
decodeTag =
    JD.map8 Tag
        (JD.field "id" JD.string)
        (JD.field "name" JD.string)
        (JD.field "slug" (JD.maybe JD.string))
        (JD.field "description" (JD.maybe JD.string))
        (JD.field "feature_image" (JD.maybe JD.string))
        (JD.field "visibility" JD.string)
        (Misc.tidDecoder "meta")
        (JD.field "url" JD.string)


view : Tag -> Html msg
view tag =
    Html.div []
        [ Log.string "id" tag.id_
        , Log.string "name" tag.name
        , Log.string_null "slug" tag.slug
        , Log.string_null "description" tag.description
        , Log.string_null "feature_image" tag.feature_image
        , Log.string "visibility" tag.visibility
        , Log.string_null "meta_title" tag.meta.title
        , Log.string_null "meta_description" tag.meta.description
        , Log.string "url" tag.url
        , Html.hr [] []
        ]
