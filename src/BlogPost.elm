module BlogPost exposing
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
  , summary: Maybe String
  , entry: String
  , data: String  -- Ex. "2016-06-12T10:18-06:00"
  -- , images: List String
  }

decode : Json.Decoder Model
decode =
  Json.object5 Model
    (Json.at ["sys", "id"] Json.string)
    (Json.at ["fields", "title"] Json.string)
    (Json.at ["fields", "summary"] (Json.maybe Json.string))
    (Json.at ["fields", "entry"] Json.string)
    (Json.at ["fields", "date"] Json.string)
    -- (Json.at ["fields", "images"] (Json.list Json.string))

-- VIEW

compactView : Model -> Html a
compactView model =
  div []
    [ h3 [class "post-title"] [text model.title]
    , h5 [class "post-summary"] [Markdown.toHtml [] (Maybe.withDefault "" model.summary)]
    ]

fullView : Model -> Html a
fullView model =
  div []
    [ h3 [class "post-title"] [text model.title]
    , h5 [class "post-summary"] [Markdown.toHtml [] (Maybe.withDefault "" model.summary)]
    , Markdown.toHtml [class "post-entry"] model.entry
    ]
