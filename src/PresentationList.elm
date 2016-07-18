module PresentationList exposing
  ( Model
  , Msg
  , init
  , view
  , update
  , urlUpdate
  , subscriptions
  )

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Task
import Presentation
import ContentfulAPI
import Router
import PagableContent

-- MODEL

type alias Model = PagableContent.Model Presentation.Model String

init : (Model, Cmd Msg)
init =
  let model = PagableContent.init [] Nothing viewOne viewMany .slug
  in
    (model, initialContent)

initialContent : Cmd Msg
initialContent =
  (ContentfulAPI.fetchPresentations 0)
  |> Cmd.map (\result ->
      case result of
        ContentfulAPI.FetchPresentations presentations ->
          PagableContent.AddItems presentations
        _ ->
          PagableContent.NoOp
    )

-- UPDATE

type alias Msg = PagableContent.Msg Presentation.Model String

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  (PagableContent.update action model, Cmd.none)

urlUpdate : Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  case route of
    Router.Presentation slug ->
      Debug.log ("Clicked presentation: " ++ slug)
      update (PagableContent.SelectItem slug) model
    _ ->
      update PagableContent.DeselectItem model

-- VIEW

view : Model -> Html Msg
view model =
  PagableContent.view model

viewOne : Presentation.Model -> Html Msg
viewOne presentation =
  let fragment = Router.toFragment Router.Presentations
  in
    div []
      [ a [class "back-button", href fragment] [text "Back to all presentations"]
      , Presentation.fullView presentation
      ]

viewMany : List Presentation.Model -> Html Msg
viewMany presentations =
  div [class "presentation-list"] [ content presentations ]

content : List Presentation.Model -> Html Msg
content presentations =
  div [] (List.map presentationEntry presentations)

presentationEntry : Presentation.Model -> Html Msg
presentationEntry presentation =
  let fragment = Router.toFragment (Router.Presentation presentation.slug)
  in
    a [class "presentation-entry", href fragment] [Presentation.compactView presentation]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  PagableContent.subscriptions model
