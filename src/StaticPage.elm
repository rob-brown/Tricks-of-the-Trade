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
  { id: String
  , title: String
  , content: String
  , order: Int
  }

decode : Json.Decoder Model
decode =
  Json.object4 Model
    (Json.at ["sys", "id"] Json.string)
    (Json.at ["fields", "title"] Json.string)
    (Json.at ["fields", "content"] Json.string)
    (Json.at ["fields", "order"] Json.int)

-- VIEW

view : Model -> Html a
view model =
  div []
    [ h3 [class "post-title"] [text model.title]
    , Markdown.toHtml [class "post-entry"] model.content
    ]