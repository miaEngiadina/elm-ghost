module Ghost.Params exposing
    ( Params
    , empty
    , fields
    , filter
    , include
    , limit
    , order
    , page
    , toString
    )

-- https://docs.ghost.org/api/content/


type alias Params =
    { include : Maybe String
    , fields : Maybe String
    , filter : Maybe String
    , limit : Maybe String
    , order : Maybe String
    , page : Maybe String
    }


empty : Params
empty =
    Params Nothing Nothing Nothing Nothing Nothing Nothing


include : String -> Params -> Params
include values p =
    { p | include = Just values }


fields : String -> Params -> Params
fields values p =
    { p | fields = Just values }


filter : String -> Params -> Params
filter values p =
    { p | filter = Just values }


limit : Int -> Params -> Params
limit value p =
    { p | limit = Just <| String.fromInt value }


order : String -> Params -> Params
order values p =
    { p | order = Just values }


page : Int -> Params -> Params
page value p =
    { p | page = Just <| String.fromInt value }


toString : Params -> String
toString p =
    ""
        |> append "include" p.include
        |> append "fields" p.fields
        |> append "filter" p.filter
        |> append "limit" p.limit
        |> append "order" p.order
        |> append "page" p.page


append : String -> Maybe String -> String -> String
append key value rslt =
    case value of
        Just string ->
            rslt ++ "&" ++ key ++ "=" ++ string

        Nothing ->
            rslt
