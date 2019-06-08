module Ghost.Authors exposing (Author, decoder, get, view)

import Ghost.Log as Log
import Ghost.Misc as Misc
import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx


type alias Author =
    { id_ : String
    , name : String
    , slug : Maybe String
    , profile_image : Maybe String
    , cover_image : Maybe String
    , bio : Maybe String
    , website : Maybe String
    , location : Maybe String
    , facebook : Maybe String
    , meta : Misc.Meta
    , url : String
    }


get : String
get =
    "authors"


decoder : JD.Decoder (List Author)
decoder =
    JD.field get (JD.list toAuthor)


toAuthor : JD.Decoder Author
toAuthor =
    JD.succeed Author
        |> JDx.andMap (JD.field "id" JD.string)
        |> JDx.andMap (JD.field "name" JD.string)
        |> JDx.andMap (JD.field "slug" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "profile_image" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "cover_image" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "bio" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "website" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "location" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "facebook" (JD.maybe JD.string))
        |> JDx.andMap (Misc.metaDecoder "meta")
        |> JDx.andMap (JD.field "url" JD.string)


view : Author -> Html msg
view author =
    Html.div []
        [ Log.string "id" author.id_
        , Log.string "name" author.name
        , Log.string_null "slug" author.slug
        , Log.string_null "profile_image" author.profile_image
        , Log.string_null "cover_image" author.cover_image
        , Log.string_null "bio" author.bio
        , Log.string_null "website" author.website
        , Log.string_null "location" author.location
        , Log.string_null "facebook" author.facebook
        , Log.string_null "meta_title" author.meta.title
        , Log.string_null "meta_description" author.meta.description
        , Log.string "url" author.url
        , Html.hr [] []
        ]
