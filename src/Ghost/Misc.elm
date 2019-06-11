module Ghost.Misc exposing
    ( At
    , HeaderFooter
    , TID
    , atDecoder
    , headerFooterDecoder
    , map
    , tidDecoder
    )

import Ghost.Log as Log
import Html exposing (Html)
import Json.Decode as JD
import Json.Decode.Extra as JDx
import Time


type alias TID =
    { title : Maybe String
    , image : Maybe String
    , description : Maybe String
    }


tidDecoder : String -> JD.Decoder TID
tidDecoder key =
    JD.map3 TID
        (JD.maybe (JD.field (key ++ "_title") JD.string))
        (JD.maybe (JD.field (key ++ "_image") JD.string))
        (JD.maybe (JD.field (key ++ "_description") JD.string))


type alias At =
    { created : Maybe Time.Posix
    , updated : Maybe Time.Posix
    , published : Maybe Time.Posix
    }


atDecoder : JD.Decoder At
atDecoder =
    JD.map3 At
        (JD.maybe (JD.field "created_at" JDx.datetime))
        (JD.maybe (JD.field "updated_at" JDx.datetime))
        (JD.maybe (JD.field "published_at" JDx.datetime))


type alias HeaderFooter =
    { head : Maybe String
    , foot : Maybe String
    }


headerFooterDecoder : String -> JD.Decoder HeaderFooter
headerFooterDecoder key =
    JD.map2 HeaderFooter
        (JD.maybe (JD.field (key ++ "_head") JD.string))
        (JD.maybe (JD.field (key ++ "_foot") JD.string))


map : JD.Decoder a -> JD.Decoder (Maybe a -> b) -> JD.Decoder b
map =
    JD.maybe >> JDx.andMap
