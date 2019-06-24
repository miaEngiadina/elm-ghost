module Ghost.Author exposing (Author, decoder, uid)

import Ghost.Misc as Misc exposing (try)
import Json.Decode exposing (Decoder, field, list, string, succeed)
import Json.Decode.Extra exposing (andMap)


type alias Author =
    { id : Maybe String
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


uid : String
uid =
    "authors"


decoder : Decoder (List Author)
decoder =
    field uid (list toAuthor)


toAuthor : Decoder Author
toAuthor =
    succeed Author
        |> try "id" string
        |> try "name" string
        |> try "slug" string
        |> try "profile_image" string
        |> try "cover_image" string
        |> try "bio" string
        |> try "website" string
        |> try "location" string
        |> try "facebook" string
        |> andMap (Misc.tidDecoder "meta")
        |> try "url" string
