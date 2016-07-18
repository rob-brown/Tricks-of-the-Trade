module HtmlExtras exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

script : List (Html.Attribute a) -> List (Html a) -> Html a
script attrs children =
  node "script" attrs children

scriptSrc : List (Html.Attribute a) -> String -> Html a
scriptSrc attrs s =
  let allAttrs = attrs ++ [ src s ]
  in
    script allAttrs []
