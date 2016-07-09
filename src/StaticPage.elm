module StaticPage exposing
  ( Model
  , decode
  , view
  )

import Json.Decode as Json
import Markdown
import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model =
  { title: String
  , content: String
  , slug: String
  , order: Int
  }

decode : Json.Decoder Model
decode =
  Json.object4 Model
    (Json.at ["fields", "title"] Json.string)
    (Json.at ["fields", "content"] Json.string)
    (Json.at ["fields", "slug"] Json.string)
    (Json.at ["fields", "order"] Json.int)

-- VIEW

view : Model -> Html a
view model =
  article []
    [ h3 [class "post-title"] [text model.title]
    , Markdown.toHtml [class "post-entry"] model.content
    ]
