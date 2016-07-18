module Presentation exposing
  ( Model
  , decode
  , compactView
  , fullView
  )

import Json.Decode as Json
import Json.Encode
import Markdown
import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model =
  { slug: String
  , title: String
  , summary: String
  , speakerDeckId: String
  , date: String
  }

decode : Json.Decoder Model
decode =
  Json.object5 Model
    (Json.at ["fields", "slug"] Json.string)
    (Json.at ["fields", "title"] Json.string)
    (Json.at ["fields", "summary"] Json.string)
    (Json.at ["fields", "speakerDeckId"] Json.string)
    (Json.at ["fields", "date"] Json.string)

-- VIEW

compactView : Model -> Html a
compactView model =
  div [class "compact-presentation"]
    [ h3 [class "presentation-title"] [text model.title]
    , h5 [class "presentation-summary"] [Markdown.toHtml [] model.summary]
    ]

fullView : Model -> Html a
fullView model =
  article [class "full-presentation"]
    [ h3 [class "presentation-title"] [text model.title]
    , h5 [class "presentation-summary"] [Markdown.toHtml [] model.summary]
    , embedPresentation model
    ]

embedPresentation model =
  let attributes =
    [ --async True
    --,
    class "speakerdeck-embed"
    , attribute "data-id" model.speakerDeckId
    , attribute "data-ratio" "1.33333333333333"
    , src "//speakerdeck.com/assets/embed.js"
    ]
  in
    node "script" attributes []


-- <div id="slideshow-player" class="slideshow-player flex-video widescreen"><div><iframe class="speakerdeck-iframe" frameborder="0" src="//speakerdeck.com/player/bb4ed7cbbbeb4c5395c050c4f8a8f560?" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true" style="border: 0px; background-color: transparent; margin: 0px; padding: 0px; border-top-left-radius: 5px; border-top-right-radius: 5px; border-bottom-right-radius: 5px; border-bottom-left-radius: 5px; width: 696px; height: 584px; background-position: initial initial; background-repeat: initial initial;"></iframe></div></div>
-- <iframe class="speakerdeck-iframe" frameborder="0" src="//speakerdeck.com/player/bb4ed7cbbbeb4c5395c050c4f8a8f560?" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true" style="border: 0px; background-color: transparent; margin: 0px; padding: 0px; border-top-left-radius: 5px; border-top-right-radius: 5px; border-bottom-right-radius: 5px; border-bottom-left-radius: 5px; width: 696px; height: 584px; background-position: initial initial; background-repeat: initial initial;"></iframe>

-- <script async class="speakerdeck-embed" data-id="e10b298a75be4749b2f495b15c3695b7" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
-- <script async class="speakerdeck-embed" data-id="e10b298a75be4749b2f495b15c3695b7" data-ratio="1.33333333333333" src="//speakerdeck.com/assets/embed.js"></script>
