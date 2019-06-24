module Ghost.Misc exposing
    ( At
    , HeaderFooter
    , TID
    , atDecoder
    , headerFooterDecoder
    , tidDecoder
    , try
    )

import Json.Decode exposing (Decoder, field, map2, map3, maybe, nullable, string, succeed)
import Json.Decode.Extra exposing (andMap, datetime)
import Json.Decode.Pipeline exposing (optional)
import Time


type alias TID =
    { title : Maybe String
    , image : Maybe String
    , description : Maybe String
    }


tidDecoder : String -> Decoder TID
tidDecoder key =
    succeed TID
        |> try (key ++ "_title") string
        |> try (key ++ "_image") string
        |> try (key ++ "_description") string


type alias At =
    { created : Maybe Time.Posix
    , updated : Maybe Time.Posix
    , published : Maybe Time.Posix
    }


atDecoder : Decoder At
atDecoder =
    succeed At
        |> try "created_at" datetime
        |> try "updated_at" datetime
        |> try "published_at" datetime


type alias HeaderFooter =
    { head : Maybe String
    , foot : Maybe String
    }


headerFooterDecoder : String -> Decoder HeaderFooter
headerFooterDecoder key =
    succeed HeaderFooter
        |> try (key ++ "_head") string
        |> try (key ++ "_foot") string


try : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
try key dec =
    optional key (maybe dec) Nothing
