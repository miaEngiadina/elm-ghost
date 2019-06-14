module Ghost.Settings exposing (Settings, decoder, uid)

import Ghost.Misc as Misc exposing (try)
import Json.Decode exposing (Decoder, field, list, map2, string, succeed)
import Json.Decode.Extra exposing (andMap)
import Json.Decode.Pipeline exposing (required)


type alias Settings =
    { title : String
    , description : String
    , logo : Maybe String
    , icon : Maybe String
    , cover_image : Maybe String
    , facebook : Maybe String
    , twitter : Maybe String
    , lang : String
    , timezone : Maybe String
    , ghost : Misc.HeaderFooter
    , navigation : List Navigation
    , codeinjection : Misc.HeaderFooter
    }


type alias Navigation =
    { label : String, url : String }


uid : String
uid =
    "settings"


decoder : Decoder Settings
decoder =
    field uid toSettings


toSettings : Decoder Settings
toSettings =
    succeed Settings
        |> required "title" string
        |> required "description" string
        |> try "logo" string
        |> try "icon" string
        |> try "cover_image" string
        |> try "facebook" string
        |> try "twitter" string
        |> required "lang" string
        |> try "timezone" string
        |> andMap (Misc.headerFooterDecoder "ghost")
        |> required "navigation" (list toNavigation)
        |> andMap (Misc.headerFooterDecoder "codeinjection")


toNavigation : Decoder Navigation
toNavigation =
    map2 Navigation
        (field "label" string)
        (field "url" string)
