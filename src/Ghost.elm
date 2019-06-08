module Ghost exposing
    ( Author
    , Config
    , Post
    , Settings
    , Tag
    , author
    , authors
    , config
    , posts
    , tags
    )

import Ghost.Authors as Author
import Ghost.Meta exposing (Meta)
import Ghost.Posts as Post
import Ghost.Settings as Settings
import Ghost.Tags as Tag
import Http
import Json.Decode as JD


type alias Config =
    { url : String
    , key : String
    , version : String
    }


type alias Author =
    Author.Author


type alias Post =
    Post.Post


type alias Settings =
    Settings.Settings


type alias Tag =
    Tag.Tag


urlFrom : Config -> String -> String
urlFrom ghost value =
    ghost.url
        ++ "/ghost/api/"
        ++ ghost.version
        ++ "/content/"
        ++ value
        ++ "/?key="
        ++ ghost.key


http : JD.Decoder g -> String -> Config -> (Result Http.Error g -> msg) -> Cmd msg
http decoder get ghost msg =
    Http.get
        { url = urlFrom ghost get
        , expect = Http.expectJson msg decoder
        }


author : String -> Config -> (Result Http.Error (List Author) -> msg) -> Cmd msg
author id_ =
    http Author.decoder (Author.get ++ "/" ++ id_)


authors : Config -> (Result Http.Error (List Author) -> msg) -> Cmd msg
authors =
    http Author.decoder Author.get


pages : Config -> (Result Http.Error (List Post) -> msg) -> Cmd msg
pages =
    http Post.decoder "pages"


page : String -> Config -> (Result Http.Error (List Post) -> msg) -> Cmd msg
page id_ =
    http Post.decoder ("pages/" ++ id_)


posts : Config -> (Result Http.Error (List Post) -> msg) -> Cmd msg
posts =
    http Post.decoder Post.get


post : String -> Config -> (Result Http.Error (List Post) -> msg) -> Cmd msg
post id_ =
    http Post.decoder (Post.get ++ "/" ++ id_)


settings : Config -> (Result Http.Error Settings -> msg) -> Cmd msg
settings =
    http Settings.decoder Settings.get


tags : Config -> (Result Http.Error (List Tag) -> msg) -> Cmd msg
tags =
    http Tag.decoder Tag.get


config : String -> String -> String -> Config
config url =
    Config <|
        if String.endsWith "/" url then
            String.dropRight 1 url

        else
            url
