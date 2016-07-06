module Router exposing (..)

import Navigation
import String
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)

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
    Post id ->
      "#posts/" ++ id
    BookReviews ->
      "#reviews"
    Review id ->
      "#reviews/" ++ id
    Page slug ->
      "#pages/" ++ slug

fragmentParser : Navigation.Location -> Result String Route
fragmentParser location =
  UrlParser.parse identity routeParser (String.dropLeft 1 location.hash)

routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ format Home (s "")
    , format Post (s "posts" </> string)
    , format Blog (s "posts")
    , format Review (s "reviews" </> string)
    , format BookReviews (s "reviews")
    , format Page (s "pages" </> string)
    ]
