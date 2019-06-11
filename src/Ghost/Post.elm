module Ghost.Post exposing (Post, decoder, uid, view)

import Ghost.Author
import Ghost.Log as Log
import Ghost.Misc as Misc
import Ghost.Tag
import Html exposing (Html)
import Html.Parser
import Json.Decode as JD
import Json.Decode.Extra as JDx
import Time


type alias Post =
    { id_ : String
    , uuid : String
    , title : String
    , slug : Maybe String
    , html : List Html.Parser.Node
    , comment_id : String
    , feature_image : Maybe String
    , featured : Bool
    , page : Bool
    , meta : Misc.TID
    , at : Misc.At
    , custom_excerpt : Maybe String
    , codeinjection : Misc.HeaderFooter
    , og : Misc.TID
    , twitter : Misc.TID
    , custom_template : Maybe String
    , canonical_url : Maybe String
    , authors : List Ghost.Author.Author
    , tags : List Ghost.Tag.Tag
    , primary_author : Maybe String
    , primary_tag : Maybe String
    , url : String
    , excerpt : Maybe String
    }


uid : String
uid =
    "posts"


decoder : JD.Decoder (List Post)
decoder =
    JD.field uid (JD.list toPost)


toPost : JD.Decoder Post
toPost =
    JD.succeed Post
        |> JDx.andMap (JD.field "id" JD.string)
        |> JDx.andMap (JD.field "uuid" JD.string)
        |> JDx.andMap (JD.field "title" JD.string)
        |> JDx.andMap (JD.field "slug" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "html" (JD.string |> JD.andThen html))
        |> JDx.andMap (JD.field "comment_id" JD.string)
        |> JDx.andMap (JD.field "feature_image" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "featured" JD.bool)
        |> JDx.andMap (JD.field "page" JD.bool)
        |> JDx.andMap (Misc.tidDecoder "meta")
        |> JDx.andMap Misc.atDecoder
        |> JDx.andMap (JD.field "custom_excerpt" (JD.maybe JD.string))
        |> JDx.andMap (Misc.headerFooterDecoder "codeinjection")
        |> JDx.andMap (Misc.tidDecoder "og")
        |> JDx.andMap (Misc.tidDecoder "twitter")
        |> JDx.andMap (JD.field "custom_template" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "canonical_url" (JD.maybe JD.string))
        |> JDx.andMap Ghost.Author.decoder
        |> JDx.andMap Ghost.Tag.decoder
        |> JDx.andMap (JD.field "primary_author" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "primary_tag" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "url" JD.string)
        |> JDx.andMap (JD.field "excerpt" (JD.maybe JD.string))


html : String -> JD.Decoder (List Html.Parser.Node)
html code =
    case Html.Parser.run code of
        Ok nodes ->
            JD.succeed nodes

        _ ->
            JD.succeed []


view : Post -> Html msg
view post =
    Html.div []
        [ Log.string "id" post.id_
        , Log.string "uuid" post.uuid
        , Log.string "title" post.title
        , Log.string_null "slug" post.slug
        , Log.html "html" post.html
        , Log.string "comment_id" post.comment_id
        , Log.string_null "feature_image" post.feature_image
        , Log.bool "featured" post.featured
        , Log.bool "page" post.page
        , Log.string_null "meta_title" post.meta.title
        , Log.string_null "meta_description" post.meta.description
        , Log.datetime "created_at" post.at.created
        , Log.datetime "updated_at" post.at.updated
        , Log.datetime "published_at" post.at.published
        , Log.string_null "custom_excerpt" post.custom_excerpt
        , Log.string_null "codeinjection_head" post.codeinjection.head
        , Log.string_null "codeinjection_foot" post.codeinjection.foot
        , Log.string_null "og_title" post.og.title
        , Log.string_null "og_image" post.og.image
        , Log.string_null "og_description" post.og.description
        , Log.string_null "twitter_image" post.twitter.image
        , Log.string_null "twitter_title" post.twitter.title
        , Log.string_null "twitter_description" post.twitter.description
        , Log.string_null "custom_template" post.custom_template
        , Log.string_null "canonical_url" post.canonical_url
        , Log.string_null "primary_author" post.primary_author
        , Log.string_null "primary_tag" post.primary_tag
        , Log.string "url" post.url
        , Log.string_null "excerpt" post.excerpt
        , Html.hr [] []
        ]
