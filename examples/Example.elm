module Example exposing
    ( Model
    , Msg(..)
    , State(..)
    , init
    , main
    , subscriptions
    , update
    , view
    )

import Browser
import Ghost
import Ghost.Params
import Html exposing (Html)
import Html.Events exposing (onClick)
import Log



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type State
    = Loading
    | Failure String
    | Success


type alias Model =
    { ghost : Ghost.Config
    , rslt : Maybe (List Ghost.Post)
    , state : State
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model
        (Ghost.config
            "http://localhost:2368/"
            "2951c7676d21b0117451fc9a5e"
            "v2"
        )
        Nothing
        Loading
    , Cmd.none
    )


type Msg
    = Load
    | GotText (Result Ghost.Error ( List Ghost.Post, Ghost.Meta ))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Load ->
            ( model
            , Ghost.Params.empty
                |> Ghost.Params.limit 1
                |> Ghost.Params.fields "id,title,html"
                |> Ghost.posts model.ghost GotText
            )

        GotText result ->
            case result of
                Ok ( fullText, _ ) ->
                    ( { model
                        | state = Success
                        , rslt = Just fullText
                      }
                    , Cmd.none
                    )

                Err info ->
                    ( { model | state = Failure <| Ghost.errorToString info }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.button [ onClick Load ] [ Html.text "load" ]
        , case model.state of
            Failure info ->
                Html.text info

            Loading ->
                Html.text "Loading..."

            Success ->
                case model.rslt of
                    Just list ->
                        Html.div []
                            [ list
                                |> List.map viewPost
                                |> Html.div []

                            --, Ghost.Meta.view meta
                            ]

                    _ ->
                        Html.text "nothing"
        ]


viewAuthor : Ghost.Author -> Html msg
viewAuthor author =
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


viewMeta : Ghost.Meta -> Html msg
viewMeta meta =
    Html.div []
        [ meta.page
            |> String.fromInt
            |> (++) "page: "
            |> Html.text
        , meta.limit
            |> String.fromInt
            |> (++) " -- limit: "
            |> Html.text
        , meta.pages
            |> String.fromInt
            |> (++) " -- pages: "
            |> Html.text
        , meta.total
            |> String.fromInt
            |> (++) " -- total: "
            |> Html.text
        ]


viewPost : Ghost.Post -> Html msg
viewPost post =
    Html.div []
        [ Log.string "id" post.id_
        , Log.string "uuid" post.uuid
        , Log.string "title" post.title
        , Log.string "slug" post.slug
        , Log.string "html" post.html
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


viewTag : Ghost.Tag -> Html msg
viewTag tag =
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


viewSettings : Ghost.Settings -> Html msg
viewSettings settings =
    Html.div []
        [ Log.log "title" settings.title
        , Log.log "description" settings.description
        , Log.string "logo" settings.logo
        , Log.string "icon" settings.icon
        , Log.string "cover_image" settings.cover_image
        , Log.string "facebook" settings.facebook
        , Log.string "twitter" settings.twitter
        , Log.log "lang" settings.lang
        , Log.string "timezone" settings.timezone
        , Log.string "ghost_head" settings.ghost.head
        , Log.string "ghost_foot" settings.ghost.foot
        , settings.navigation
            |> List.map (\n -> Html.span [] [ Log.log "label" n.label, Log.log "url" n.url ])
            |> Html.span []
        , Log.string "codeinjection_head" settings.codeinjection.head
        , Log.string "codeinjection_foot" settings.codeinjection.head
        , Html.hr [] []
        ]



{--
html : String -> List Html.Parser.Node
html code =
    case Html.Parser.run code of
        Ok nodes ->
            nodes

        _ ->
            []
--}
