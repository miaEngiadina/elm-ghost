module Ghost.Params exposing
    ( empty, fields, filter, include, limit, order, page, toString
    , Params
    )

{-| This module is used for any kind of configuration that is associated with
requests, such as limiting the number of results, filtering, order, etc..

See <https://docs.ghost.org/api/content/> for further information on all settings.

@docs empty, fields, filter, include, limit, order, page, toString

@docs Params

-}

import Url


{-| A basic record for all ghost related fine tune settings.
-}
type alias Params =
    { include : Maybe String
    , fields : Maybe String
    , filter : Maybe String
    , limit : Maybe String
    , order : Maybe String
    , page : Maybe String
    }


{-| Initialise an empty Parameter record. This is a shortcut for:

    Params Nothing Nothing Nothing Nothing Nothing Nothing

-}
empty : Params
empty =
    Params Nothing Nothing Nothing Nothing Nothing Nothing


{-| `include` takes a string of comma-separated parameters, such as:

    * Posts & Pages: authors, tags
    * Authors: count.posts
    * Tags: count.posts

    Params.empty
    |> Params.include "authors,count.posts"
    |> ...

which allow to fine tune the returned result.

See: <https://docs.ghost.org/api/content/#include>

-}
include : String -> Params -> Params
include values p =
    { p | include = Just values }


{-| `fields` takes in a string of comma-separated fields, that will be returned
by ghost. Since it allows to filter any kind of field, such as "id", "title",
"url", "authors", etc. all ghost types are defined as Maybe types.

    Params.empty
    |> Params.fields "url,id" -- everything else is dissmissed
    |> ...

See: <https://docs.ghost.org/api/content/#fields>

-}
fields : String -> Params -> Params
fields values p =
    { p | fields = Just values }


{-| Takes in a string of comma-separated filters, to fine tune the response.

    Params.empty
    |> Params.filter "featured:true,tag:getting-started"
    |> ...

See: <https://docs.ghost.org/api/content/#filter>

-}
filter : String -> Params -> Params
filter values p =
    { p | filter = Just values }


{-| Limit the number of records returned, the default value is 15, the nagative
value -1 will return all results.

    Params.empty
    |> Params.limit 2
    |> ...

See: <https://docs.ghost.org/api/content/#limit>

-}
limit : Int -> Params -> Params
limit value p =
    { p
        | limit =
            Just <|
                if value == -1 then
                    "all"

                else
                    String.fromInt value
    }


{-| Define the sort order:

    Params.empty
    |> Params.order "published_at DESC"
    |> ...

See: <https://docs.ghost.org/api/content/#order>

-}
order : String -> Params -> Params
order values p =
    { p | order = Just <| Url.percentEncode values }


{-| By default, the first 15 records are returned.

    Params.empty
    |> Params.limit 2
    |> Params.page 2
    |> ...

See: <https://docs.ghost.org/api/content/#order>

-}
page : Int -> Params -> Params
page value p =
    { p | page = Just <| String.fromInt value }


{-| Used internally only, to generate a string from all parameters.
-}
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
