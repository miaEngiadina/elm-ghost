module Ghost.Error exposing
    ( Error
    , decoder
    , uid
    )

import Json.Decode as JD


type alias Error =
    { message : String
    , errorType : String
    }


uid : String
uid =
    "errors"


decoder : JD.Decoder (List Error)
decoder =
    JD.field uid (JD.list toError)


toError : JD.Decoder Error
toError =
    JD.map2 Error
        (JD.field "message" JD.string)
        (JD.field "errorType" JD.string)
