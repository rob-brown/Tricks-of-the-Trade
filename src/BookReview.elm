module BookReview exposing
  ( Model
  , decode
  , compactView
  , fullView
  )

import Json.Decode as Json
import Markdown
import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model =
  { slug: String
  , title: String
  , subtitle: Maybe String
  , author: String
  , url: String
  , review: String
  }

decode : Json.Decoder Model
decode =
  Json.map6 Model
    (Json.at ["fields", "slug"] Json.string)
    (Json.at ["fields", "bookTitle"] Json.string)
    (Json.at ["fields", "bookSubtitle"] (Json.maybe Json.string))
    (Json.at ["fields", "author"] Json.string)
    (Json.at ["fields", "url"] Json.string)
    (Json.at ["fields", "review"] Json.string)

-- VIEW

compactView : Model -> Html a
compactView model =
  div [class "compact-review"]
    [ h3 [class "book-title"] [text model.title]
    , h5 [class "book-author"] [text ("by " ++ model.author)]
    ]

fullView : Model -> Html a
fullView model =
  article [class "full-review"]
    [ h3 [class "book-title"] [text model.title]
    , h4 [class "book-subtitle"] [text (Maybe.withDefault "" model.subtitle)]
    , h5 [class "book-author"] [text ("by " ++ model.author)]
    , Markdown.toHtml [class "book-review"] model.review
    ]
