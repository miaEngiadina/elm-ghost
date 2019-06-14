module Ghost.Misc exposing
    ( At
    , HeaderFooter
    , TID
    , atDecoder
    , headerFooterDecoder
    , tidDecoder
    , try
    )

import Json.Decode exposing (Decoder, field, map2, map3, maybe, string)
import Json.Decode.Extra exposing (andMap, datetime)
import Time


type alias TID =
    { title : Maybe String
    , image : Maybe String
    , description : Maybe String
    }


tidDecoder : String -> Decoder TID
tidDecoder key =
    map3 TID
        (maybe (field (key ++ "_title") string))
        (maybe (field (key ++ "_image") string))
        (maybe (field (key ++ "_description") string))


type alias At =
    { created : Maybe Time.Posix
    , updated : Maybe Time.Posix
    , published : Maybe Time.Posix
    }


atDecoder : Decoder At
atDecoder =
    map3 At
        (maybe (field "created_at" datetime))
        (maybe (field "updated_at" datetime))
        (maybe (field "published_at" datetime))


type alias HeaderFooter =
    { head : Maybe String
    , foot : Maybe String
    }


headerFooterDecoder : String -> Decoder HeaderFooter
headerFooterDecoder key =
    map2 HeaderFooter
        (maybe (field (key ++ "_head") string))
        (maybe (field (key ++ "_foot") string))


try : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
try key dec =
    field key dec |> maybe |> andMap
