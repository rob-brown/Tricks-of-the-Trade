module Router exposing (..)

import Navigation
import String
import UrlParser exposing (Parser, (</>), int, oneOf, s, string)

type Route
  = Home
  | Blog
  | Post String
  | BookReviews
  | Review String
  | Page String

toFragment : Route -> String
toFragment route =
  case route of
    Home ->
      ""
    Blog ->
      "#posts"
    Post slug ->
      "#posts/" ++ slug
    BookReviews ->
      "#reviews"
    Review slug ->
      "#reviews/" ++ slug
    Page slug ->
      "#pages/" ++ slug

fragmentParser : Navigation.Location -> Maybe Route
fragmentParser location =
  UrlParser.parseHash routeParser location

routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ UrlParser.map Blog (s "")
    , UrlParser.map Post (s "posts" </> string)
    , UrlParser.map Blog (s "posts")
    , UrlParser.map Review (s "reviews" </> string)
    , UrlParser.map BookReviews (s "reviews")
    , UrlParser.map Page (s "pages" </> string)
    ]
