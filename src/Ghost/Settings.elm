module Ghost.Settings exposing (Settings, decoder, get, view)

import Ghost.Log as Log
import Ghost.Misc as Misc
import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx


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


get : String
get =
    "settings"


decoder : JD.Decoder Settings
decoder =
    JD.field get toSettings


toSettings : JD.Decoder Settings
toSettings =
    JD.succeed Settings
        |> JDx.andMap (JD.field "title" JD.string)
        |> JDx.andMap (JD.field "description" JD.string)
        |> JDx.andMap (JD.field "logo" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "icon" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "cover_image" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "facebook" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "twitter" (JD.maybe JD.string))
        |> JDx.andMap (JD.field "lang" JD.string)
        |> JDx.andMap (JD.field "timezone" (JD.maybe JD.string))
        |> JDx.andMap Misc.headerFooterDecoder
        |> JDx.andMap (JD.field "navigation" (JD.list toNavigation))
        |> JDx.andMap Misc.headerFooterDecoder


toNavigation : JD.Decoder Navigation
toNavigation =
    JD.map2 Navigation
        (JD.field "label" JD.string)
        (JD.field "url" JD.string)


view : Settings -> Html msg
view settings =
    Html.div []
        [ Log.string "title" settings.title
        , Log.string "description" settings.description
        , Log.string_null "logo" settings.logo
        , Log.string_null "icon" settings.icon
        , Log.string_null "cover_image" settings.cover_image
        , Log.string_null "facebook" settings.facebook
        , Log.string_null "twitter" settings.twitter
        , Log.string "lang" settings.lang
        , Log.string_null "timezone" settings.timezone
        , Log.string_null "ghost_head" settings.ghost.head
        , Log.string_null "ghost_foot" settings.ghost.foot
        , settings.navigation
            |> List.map (\n -> Html.span [] [ Log.string "label" n.label, Log.string "url" n.url ])
            |> Html.span []
        , Log.string_null "codeinjection_head" settings.codeinjection.head
        , Log.string_null "codeinjection_foot" settings.codeinjection.head
        , Html.hr [] []
        ]
