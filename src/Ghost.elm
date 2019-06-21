module Ghost exposing
    ( Author, Config, Error(..), Meta, Post, Settings, Tag
    , authors, authorsById, authorsBySlug, config, errorToString, pages, pagesById, pagesBySlug, posts, postsById, postsBySlug, settings, tags, tagsById, tagsBySlug
    )

{-| This module contains all functions to access any kind of ghost related
resource, these are `Config`,
`Author`s, `Error`s, `Mata`, `Post`s, `Settings`s, `Tag`s.

See <https://docs.ghost.org/api/content/#resources>

@docs Author, Config, Error, Meta, Post, Settings, Tag

@docs authors, authorsById, authorsBySlug, config, errorToString, pages, pagesById, pagesBySlug, posts, postsById, postsBySlug, settings, tags, tagsById, tagsBySlug

-}

import Ghost.Author as Author
import Ghost.Error as Error
import Ghost.Meta as Meta
import Ghost.Params as Params exposing (Params)
import Ghost.Post as Post
import Ghost.Settings as Settings
import Ghost.Tag as Tag
import Http
import Json.Decode exposing (Decoder, decodeString)
import Task


{-| A record for the basic ghost configuration:

    Config url key "v2"

The version currently is always "v2", which might change later. The key to
access the api has to be generated as described in:

<https://docs.ghost.org/api/content/#key>

-}
type alias Config =
    { url : String
    , key : String
    , version : String
    }


{-| A record for all author related information.
-}
type alias Author =
    Author.Author


{-| `Meta` information are part of every HTTP response, except for `settings`
and contain pagination related information:

<https://docs.ghost.org/api/content/#pagination>

-}
type alias Meta =
    Meta.Meta


{-| A record for all post related information.
-}
type alias Post =
    Post.Post


{-| A record for all tag related information.
-}
type alias Tag =
    Tag.Tag


{-| A record for all setting related information.
-}
type alias Settings =
    Settings.Settings


{-| A Ghost Error is a combined type of `GhostError` and `HttpError`.
-}
type Error
    = GhostError (List Error.Error)
    | HttpError Http.Error


urlFrom : Config -> Params -> String -> String
urlFrom c p value =
    c.url
        ++ "/ghost/api/"
        ++ c.version
        ++ "/content/"
        ++ value
        ++ "/?key="
        ++ c.key
        ++ Params.toString p


httpErr : Http.Error -> Result Error value
httpErr =
    HttpError >> Err


responseHandler : Decoder a -> Http.Response String -> Result Error a
responseHandler decoder response =
    case response of
        Http.BadUrl_ url ->
            httpErr (Http.BadUrl url)

        Http.Timeout_ ->
            httpErr Http.Timeout

        Http.BadStatus_ { statusCode } info ->
            if statusCode == 422 then
                case decodeString Error.decoder info of
                    Ok json ->
                        json |> GhostError |> Err

                    Err _ ->
                        httpErr (Http.BadBody info)

            else
                httpErr (Http.BadStatus statusCode)

        Http.NetworkError_ ->
            httpErr Http.NetworkError

        Http.GoodStatus_ _ body ->
            case decodeString decoder body of
                Err _ ->
                    httpErr (Http.BadBody body)

                Ok rslt ->
                    Ok rslt


http : Decoder a -> String -> Config -> (Result Error a -> msg) -> Params -> Cmd msg
http decoder get ghost msg params =
    { method = "get"
    , headers = []
    , url = urlFrom ghost params get
    , body = Http.emptyBody
    , resolver = decoder |> responseHandler |> Http.stringResolver
    , timeout = Nothing
    }
        |> Http.task
        |> Task.attempt msg


{-| Request authors from the ghost api, see <https://docs.ghost.org/api/content/#authors>

    Params.empty
    |> ...
    |> authors (Config url key "v2") GotAuthors

-}
authors : Config -> (Result Error ( List Author, Meta ) -> msg) -> Params -> Cmd msg
authors =
    http
        (Meta.decoder Author.decoder)
        Author.uid


{-| Request authors from the ghost api, see <https://docs.ghost.org/api/content/#authors>

    Params.empty
    |> ...
    |> authorsById id (Config url key "v2") GotAuthors

-}
authorsById : String -> Config -> (Result Error ( List Author, Meta ) -> msg) -> Params -> Cmd msg
authorsById id =
    http
        (Meta.decoder Author.decoder)
        (Author.uid ++ "/" ++ id)


{-| Request authors from the ghost api, see <https://docs.ghost.org/api/content/#authors>

    Params.empty
    |> ...
    |> authorsBySlug id (Config url key "v2") GotAuthors

-}
authorsBySlug : String -> Config -> (Result Error ( List Author, Meta ) -> msg) -> Params -> Cmd msg
authorsBySlug id =
    http
        (Meta.decoder Author.decoder)
        (Author.uid ++ "/slug" ++ id)


{-| Request pages from the ghost api, see <https://docs.ghost.org/api/content/#pages>

    Params.empty
    |> ...
    |> pages (Config url key "v2") GotPages

-}
pages : Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
pages =
    http
        (Meta.decoder Post.decoder)
        "pages"


{-| Request pages from the ghost api, see <https://docs.ghost.org/api/content/#pages>

    Params.empty
    |> ...
    |> pagesById id (Config url key "v2") GotPages

-}
pagesById : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
pagesById id =
    http
        (Meta.decoder Post.decoder)
        ("pages/" ++ id)


{-| Request pages from the ghost api, see <https://docs.ghost.org/api/content/#pages>

    Params.empty
    |> ...
    |> pagesBySlug id (Config url key "v2") GotPages

-}
pagesBySlug : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
pagesBySlug id =
    http
        (Meta.decoder Post.decoder)
        ("pages/slug/" ++ id)


{-| Request posts from the ghost api, see <https://docs.ghost.org/api/content/#posts>

    Params.empty
    |> ...
    |> posts (Config url key "v2") GotPosts

-}
posts : Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
posts =
    http
        (Meta.decoder Post.decoder)
        Post.uid


{-| Request posts from the ghost api, see <https://docs.ghost.org/api/content/#posts>

    Params.empty
    |> ...
    |> postsById id (Config url key "v2") GotPosts

-}
postsById : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
postsById id =
    http
        (Meta.decoder Post.decoder)
        (Post.uid ++ "/" ++ id)


{-| Request posts from the ghost api, see <https://docs.ghost.org/api/content/#posts>

    Params.empty
    |> ...
    |> postsBySlug id (Config url key "v2") GotPosts

-}
postsBySlug : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
postsBySlug id =
    http
        (Meta.decoder Post.decoder)
        (Post.uid ++ "/slug/" ++ id)


{-| Request tags from the ghost api, see <https://docs.ghost.org/api/content/#settings>

    Params.empty
    |> ...
    |> tagsBySlug id (Config url key "v2") GotSettings

In contrast to all other requests, you will receive a single record.

-}
settings : Config -> (Result Error Settings -> msg) -> Params -> Cmd msg
settings =
    http
        Settings.decoder
        Settings.uid


{-| Request tags from the ghost api, see <https://docs.ghost.org/api/content/#tags>

    Params.empty
    |> Params.fields ...
    |> ...
    |> tags (Config url key "v2") GotTags

-}
tags : Config -> (Result Error ( List Tag, Meta ) -> msg) -> Params -> Cmd msg
tags =
    http
        (Meta.decoder Tag.decoder)
        Tag.uid


{-| Request tags from the ghost api, see <https://docs.ghost.org/api/content/#tags>

    Params.empty
    |> Params.fields ...
    |> ...
    |> tagsById id (Config url key "v2") GotTags

-}
tagsById : String -> Config -> (Result Error ( List Tag, Meta ) -> msg) -> Params -> Cmd msg
tagsById id =
    http
        (Meta.decoder Tag.decoder)
        (Tag.uid ++ "/" ++ id)


{-| Request tags from the ghost api, see <https://docs.ghost.org/api/content/#tags>

    Params.empty
    |> Params.fields ...
    |> ...
    |> tagsBySlug id (Config url key "v2") GotTags

-}
tagsBySlug : String -> Config -> (Result Error ( List Tag, Meta ) -> msg) -> Params -> Cmd msg
tagsBySlug id =
    http
        (Meta.decoder Tag.decoder)
        (Tag.uid ++ "/slug/" ++ id)


{-| A clean way of initializing the basic configuration settings, that takes
care of the url-ending.
-}
config : String -> String -> String -> Config
config url =
    Config <|
        if String.endsWith "/" url then
            String.dropRight 1 url

        else
            url


{-| Pass in a `Ghost.Error` and it will return a string of wheater it is
a `HttpError` or a ghost related Error.
-}
errorToString : Error -> String
errorToString error =
    case error of
        HttpError Http.Timeout ->
            "HTTP timeout"

        HttpError Http.NetworkError ->
            "HTTP network error"

        HttpError (Http.BadStatus stat) ->
            "HTTP bad status " ++ String.fromInt stat

        HttpError (Http.BadUrl info) ->
            "HTTP bad url " ++ info

        HttpError (Http.BadBody info) ->
            "HTTP bad body " ++ info

        GhostError info ->
            info
                |> List.map (\i -> "\nerrorType: " ++ i.errorType ++ "; message: " ++ i.message)
                |> String.concat
                |> (++) "GHOST"
