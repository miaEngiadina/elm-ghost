module Ghost.Tag exposing (Tag, decoder, uid, view)

import Ghost.Log as Log
import Ghost.Misc as Misc
import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx


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


decoder : JD.Decoder (List Tag)
decoder =
    JD.field uid (JD.list decodeTag)


decodeTag : JD.Decoder Tag
decodeTag =
    JD.map8 Tag
        (JD.maybe (JD.field "id" JD.string))
        (JD.maybe (JD.field "name" JD.string))
        (JD.maybe (JD.field "slug" JD.string))
        (JD.maybe (JD.field "description" JD.string))
        (JD.maybe (JD.field "feature_image" JD.string))
        (JD.maybe (JD.field "visibility" JD.string))
        (Misc.tidDecoder "meta")
        (JD.maybe (JD.field "url" JD.string))


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
