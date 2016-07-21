module BlogPost exposing
  ( Model
  , decode
  , compactView
  , fullView
  )

import Json.Decode as Json
import Markdown
import String
import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model =
  { slug: String
  , title: String
  , summary: Maybe String
  , entry: String
  , date: String  -- Ex. "2016-06-12T10:18-06:00"
  }

decode : Json.Decoder Model
decode =
  Json.object5 Model
    (Json.at ["fields", "slug"] Json.string)
    (Json.at ["fields", "title"] Json.string)
    (Json.at ["fields", "summary"] (Json.maybe Json.string))
    (Json.at ["fields", "entry"] Json.string)
    (Json.at ["fields", "date"] Json.string)

-- VIEW

compactView : Model -> Html a
compactView model =
  div [class "compact-post"]
    [ h3 [class "post-title"] [text model.title]
    , h5 [class "date"] [formatDate model]
    , h5 [class "post-summary"] [Markdown.toHtml [] (Maybe.withDefault "" model.summary)]
    ]

fullView : Model -> Html a
fullView model =
  article [class "full-post"]
    [ h3 [class "post-title"] [text model.title]
    , h5 [class "date"] [formatDate model]
    , h4 [class "post-summary"] [Markdown.toHtml [] (Maybe.withDefault "" model.summary)]
    , Markdown.toHtml [class "post-body"] model.entry
    ]

formatDate : Model -> Html a
formatDate model =
  model.date
  |> Date.fromString
  |> Result.map dateToString
  |> Result.withDefault ""
  |> text

dateToString : Date -> String
dateToString date =
  let
    day = date |> Date.day |> toString
    month = date |> Date.month |> toString
    year = date |> Date.year |> toString
  in
    String.join " " [day, month, year]
