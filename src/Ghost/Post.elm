module Ghost.Post exposing (Post, decoder, uid, view)

import Ghost.Author
import Ghost.Log as Log
import Ghost.Misc as Misc exposing (map)
import Ghost.Tag
import Html exposing (Html)
import Html.Parser
import Json.Decode as JD
import Json.Decode.Extra as JDx
import Time


type alias Post =
    { id_ : Maybe String
    , uuid : Maybe String
    , title : Maybe String
    , slug : Maybe String
    , html : Maybe (List Html.Parser.Node)
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


decoder : JD.Decoder (List Post)
decoder =
    JD.field uid (JD.list toPost)


toPost : JD.Decoder Post
toPost =
    JD.succeed Post
        |> map (JD.field "id" JD.string)
        |> map (JD.field "uuid" JD.string)
        |> map (JD.field "title" JD.string)
        |> map (JD.field "slug" JD.string)
        |> map (JD.field "html" (JD.string |> JD.andThen html))
        |> map (JD.field "comment_id" JD.string)
        |> map (JD.field "feature_image" JD.string)
        |> map (JD.field "featured" JD.bool)
        |> map (JD.field "page" JD.bool)
        |> JDx.andMap (Misc.tidDecoder "meta")
        |> JDx.andMap Misc.atDecoder
        |> map (JD.field "custom_excerpt" JD.string)
        |> JDx.andMap (Misc.headerFooterDecoder "codeinjection")
        |> JDx.andMap (Misc.tidDecoder "og")
        |> JDx.andMap (Misc.tidDecoder "twitter")
        |> map (JD.field "custom_template" JD.string)
        |> map (JD.field "canonical_url" JD.string)
        |> map Ghost.Author.decoder
        |> map Ghost.Tag.decoder
        |> map (JD.field "primary_author" JD.string)
        |> map (JD.field "primary_tag" JD.string)
        |> map (JD.field "url" JD.string)
        |> map (JD.field "excerpt" JD.string)


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
        , Log.string "slug" post.slug
        , Log.html "html" post.html
        , Log.string "comment_id" post.comment_id
        , Log.string "feature_image" post.feature_image
        , Log.bool "featured" post.featured
        , Log.bool "page" post.page
        , Log.string "meta_title" post.meta.title
        , Log.string "meta_description" post.meta.description
        , Log.datetime "created_at" post.at.created
        , Log.datetime "updated_at" post.at.updated
        , Log.datetime "published_at" post.at.published
        , Log.string "custom_excerpt" post.custom_excerpt
        , Log.string "codeinjection_head" post.codeinjection.head
        , Log.string "codeinjection_foot" post.codeinjection.foot
        , Log.string "og_title" post.og.title
        , Log.string "og_image" post.og.image
        , Log.string "og_description" post.og.description
        , Log.string "twitter_image" post.twitter.image
        , Log.string "twitter_title" post.twitter.title
        , Log.string "twitter_description" post.twitter.description
        , Log.string "custom_template" post.custom_template
        , Log.string "canonical_url" post.canonical_url
        , Log.string "primary_author" post.primary_author
        , Log.string "primary_tag" post.primary_tag
        , Log.string "url" post.url
        , Log.string "excerpt" post.excerpt
        , Html.hr [] []
        ]
