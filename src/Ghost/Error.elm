module Ghost.Error exposing
    ( Error
    , decoder
    , uid
    )

import Json.Decode exposing (Decoder, field, list, map2, string)


type alias Error =
    { message : String
    , errorType : String
    }


uid : String
uid =
    "errors"


decoder : Decoder (List Error)
decoder =
    field uid (list toError)


toError : Decoder Error
toError =
    map2 Error
        (field "message" string)
        (field "errorType" string)
