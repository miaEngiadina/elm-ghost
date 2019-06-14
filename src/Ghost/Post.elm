module Ghost.Post exposing (Post, decoder, uid)

import Ghost.Author
import Ghost.Misc as Misc exposing (try)
import Ghost.Tag
import Json.Decode exposing (Decoder, bool, field, list, maybe, string, succeed)
import Json.Decode.Extra exposing (andMap)
import Time


type alias Post =
    { id_ : Maybe String
    , uuid : Maybe String
    , title : Maybe String
    , slug : Maybe String
    , html : Maybe String
    , comment_id : Maybe String
    , feature_image : Maybe String
    , featured : Maybe Bool
    , page : Maybe Bool
    , meta : Misc.TID
    , at : Misc.At
    , custom_excerpt : Maybe String
    , codeinjection : Misc.HeaderFooter
    , og : Misc.TID
    , twitter : Misc.TID
    , custom_template : Maybe String
    , canonical_url : Maybe String
    , authors : Maybe (List Ghost.Author.Author)
    , tags : Maybe (List Ghost.Tag.Tag)
    , primary_author : Maybe String
    , primary_tag : Maybe String
    , url : Maybe String
    , excerpt : Maybe String
    }


uid : String
uid =
    "posts"


decoder : Decoder (List Post)
decoder =
    field uid (list toPost)


toPost : Decoder Post
toPost =
    succeed Post
        |> try "id" string
        |> try "uuid" string
        |> try "title" string
        |> try "slug" string
        |> try "html" string
        |> try "comment_id" string
        |> try "feature_image" string
        |> try "featured" bool
        |> try "page" bool
        |> andMap (Misc.tidDecoder "meta")
        |> andMap Misc.atDecoder
        |> try "custom_excerpt" string
        |> andMap (Misc.headerFooterDecoder "codeinjection")
        |> andMap (Misc.tidDecoder "og")
        |> andMap (Misc.tidDecoder "twitter")
        |> try "custom_template" string
        |> try "canonical_url" string
        |> andMap (maybe Ghost.Author.decoder)
        |> andMap (maybe Ghost.Tag.decoder)
        |> try "primary_author" string
        |> try "primary_tag" string
        |> try "url" string
        |> try "excerpt" string
