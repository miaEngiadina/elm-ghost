module Ghost.Misc exposing
    ( At
    , HeaderFooter
    , Meta
    , atDecoder
    , headerFooterDecoder
    , metaDecoder
    )

import Ghost.Log as Log
import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx
import Time


type alias Meta =
    { title : Maybe String
    , image : Maybe String
    , description : Maybe String
    }


metaDecoder : String -> JD.Decoder Meta
metaDecoder key =
    JD.map3 Meta
        (JD.maybe (JD.field (key ++ "_title") JD.string))
        (JD.maybe (JD.field (key ++ "_image") JD.string))
        (JD.maybe (JD.field (key ++ "_description") JD.string))


type alias At =
    { created : Time.Posix
    , updated : Time.Posix
    , published : Time.Posix
    }


atDecoder : JD.Decoder At
atDecoder =
    JD.map3 At
        (JD.field "created_at" JDx.datetime)
        (JD.field "updated_at" JDx.datetime)
        (JD.field "published_at" JDx.datetime)


type alias HeaderFooter =
    { head : Maybe String
    , foot : Maybe String
    }


headerFooterDecoder : String -> JD.Decoder HeaderFooter
headerFooterDecoder key =
    JD.map2 HeaderFooter
        (JD.maybe (JD.field (key ++ "_head") JD.string))
        (JD.maybe (JD.field (key ++ "_foot") JD.string))
