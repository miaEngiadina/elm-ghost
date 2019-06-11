module Ghost exposing
    ( Author
    , Config
    , Error(..)
    , Meta
    , Params
    , Post
    , Settings
    , Tag
    , authors
    , authorsById
    , authorsBySlug
    , config
    , errorToString
    , pages
    , pagesById
    , pagesBySlug
    , posts
    , postsById
    , postsBySlug
    , settings
    , tags
    , tagsById
    , tagsBySlug
    , urlFrom
    )

import Ghost.Author as Author
import Ghost.Error as Error
import Ghost.Meta as Meta
import Ghost.Params as Params
import Ghost.Post as Post
import Ghost.Settings as Settings
import Ghost.Tag as Tag
import Http
import Json.Decode as JD
import Json.Decode.Extra as JDx
import Task


type alias Config =
    { url : String
    , key : String
    , version : String
    }


type alias Params =
    Params.Params


type alias Author =
    Author.Author


type alias Meta =
    Meta.Meta


type alias Post =
    Post.Post


type alias Tag =
    Tag.Tag


type alias Settings =
    Settings.Settings


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


responseHandler : JD.Decoder a -> Http.Response String -> Result Error a
responseHandler decoder response =
    case response of
        Http.BadUrl_ url ->
            httpErr (Http.BadUrl url)

        Http.Timeout_ ->
            httpErr Http.Timeout

        Http.BadStatus_ { statusCode } info ->
            if statusCode == 422 then
                case JD.decodeString Error.decoder info of
                    Ok json ->
                        json |> GhostError |> Err

                    Err msg ->
                        httpErr (Http.BadBody info)

            else
                httpErr (Http.BadStatus statusCode)

        Http.NetworkError_ ->
            httpErr Http.NetworkError

        Http.GoodStatus_ _ body ->
            case JD.decodeString decoder body of
                Err _ ->
                    httpErr (Http.BadBody body)

                Ok rslt ->
                    Ok rslt


http : JD.Decoder a -> String -> Config -> (Result Error a -> msg) -> Params -> Cmd msg
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


authors : Config -> (Result Error ( List Author, Meta ) -> msg) -> Params -> Cmd msg
authors =
    http
        (Meta.decoder Author.decoder)
        Author.uid


authorsById : String -> Config -> (Result Error ( List Author, Meta ) -> msg) -> Params -> Cmd msg
authorsById id_ =
    http
        (Meta.decoder Author.decoder)
        (Author.uid ++ "/" ++ id_)


authorsBySlug : String -> Config -> (Result Error ( List Author, Meta ) -> msg) -> Params -> Cmd msg
authorsBySlug id_ =
    http
        (Meta.decoder Author.decoder)
        (Author.uid ++ "/slug" ++ id_)


pages : Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
pages =
    http
        (Meta.decoder Post.decoder)
        "pages"


pagesById : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
pagesById id_ =
    http
        (Meta.decoder Post.decoder)
        ("pages/" ++ id_)


pagesBySlug : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
pagesBySlug id_ =
    http
        (Meta.decoder Post.decoder)
        ("pages/slug/" ++ id_)


posts : Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
posts =
    http
        (Meta.decoder Post.decoder)
        Post.uid


postsById : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
postsById id_ =
    http
        (Meta.decoder Post.decoder)
        (Post.uid ++ "/" ++ id_)


postsBySlug : String -> Config -> (Result Error ( List Post, Meta ) -> msg) -> Params -> Cmd msg
postsBySlug id_ =
    http
        (Meta.decoder Post.decoder)
        (Post.uid ++ "/slug/" ++ id_)


settings : Config -> (Result Error Settings -> msg) -> Params -> Cmd msg
settings =
    http
        Settings.decoder
        Settings.uid


tags : Config -> (Result Error ( List Tag, Meta ) -> msg) -> Params -> Cmd msg
tags =
    http
        (Meta.decoder Tag.decoder)
        Tag.uid


tagsById : String -> Config -> (Result Error ( List Tag, Meta ) -> msg) -> Params -> Cmd msg
tagsById id_ =
    http
        (Meta.decoder Tag.decoder)
        (Tag.uid ++ "/" ++ id_)


tagsBySlug : String -> Config -> (Result Error ( List Tag, Meta ) -> msg) -> Params -> Cmd msg
tagsBySlug id_ =
    http
        (Meta.decoder Tag.decoder)
        (Tag.uid ++ "/slug/" ++ id_)


config : String -> String -> String -> Config
config url =
    Config <|
        if String.endsWith "/" url then
            String.dropRight 1 url

        else
            url


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
