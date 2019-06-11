module Ghost.Author exposing (Author, decoder, uid, view)

import Ghost.Log as Log
import Ghost.Misc as Misc exposing (map)
import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx


type alias Author =
    { id_ : Maybe String
    , name : Maybe String
    , slug : Maybe String
    , profile_image : Maybe String
    , cover_image : Maybe String
    , bio : Maybe String
    , website : Maybe String
    , location : Maybe String
    , facebook : Maybe String
    , meta : Misc.TID
    , url : Maybe String
    }



--authorsById : String ->


uid : String
uid =
    "authors"


decoder : JD.Decoder (List Author)
decoder =
    JD.field uid (JD.list toAuthor)


toAuthor : JD.Decoder Author
toAuthor =
    JD.succeed Author
        |> map (JD.field "id" JD.string)
        |> map (JD.field "name" JD.string)
        |> map (JD.field "slug" JD.string)
        |> map (JD.field "profile_image" JD.string)
        |> map (JD.field "cover_image" JD.string)
        |> map (JD.field "bio" JD.string)
        |> map (JD.field "website" JD.string)
        |> map (JD.field "location" JD.string)
        |> map (JD.field "facebook" JD.string)
        |> JDx.andMap (Misc.tidDecoder "meta")
        |> map (JD.field "url" JD.string)


view : Author -> Html msg
view author =
    Html.div []
        [ Log.string "id" author.id_
        , Log.string "name" author.name
        , Log.string "slug" author.slug
        , Log.string "profile_image" author.profile_image
        , Log.string "cover_image" author.cover_image
        , Log.string "bio" author.bio
        , Log.string "website" author.website
        , Log.string "location" author.location
        , Log.string "facebook" author.facebook
        , Log.string "meta_title" author.meta.title
        , Log.string "meta_description" author.meta.description
        , Log.string "url" author.url
        , Html.hr [] []
        ]
