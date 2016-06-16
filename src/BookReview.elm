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
  { id: String
  , title: String
  , subtitle: Maybe String
  , author: String
  , url: String
  , review: String
  }

decode : Json.Decoder Model
decode =
  Json.object6 Model
    (Json.at ["sys", "id"] Json.string)
    (Json.at ["fields", "bookTitle"] Json.string)
    (Json.at ["fields", "bookSubtitle"] (Json.maybe Json.string))
    (Json.at ["fields", "author"] Json.string)
    (Json.at ["fields", "url"] Json.string)
    (Json.at ["fields", "review"] Json.string)

-- VIEW

compactView : Model -> Html a
compactView model =
  div []
    [ h3 [class "book-title"] [text model.title]
    , h4 [class "book-subtitle"] [text (Maybe.withDefault "" model.subtitle)]
    , h5 [class "book-author"] [text ("by " ++ model.author)]
    , Markdown.toHtml [class "book-review"] model.review
    ]

fullView : Model -> Html a
fullView model =
  div []
    [ h3 [class "book-title"] [text model.title]
    , h4 [class "book-subtitle"] [text (Maybe.withDefault "" model.subtitle)]
    , h5 [class "book-author"] [text ("by " ++ model.author)]
    , Markdown.toHtml [class "book-review"] model.review
    ]
