module BookReviewList exposing
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
import BookReview
import ContentfulAPI
import Router

-- MODEL

type alias Model =
  { reviews: List BookReview.Model
  , selected: Maybe String
  }

init : (Model, Cmd Msg)
init =
  let
    reviews = []
    model = { reviews=reviews, selected=Nothing }
    command = Cmd.map Content (ContentfulAPI.fetchBookReviews 0)
  in
    (model, command)

-- UPDATE

type Msg
  = Content ContentfulAPI.Msg
  | SelectReview String
  | DeselectReview

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    SelectReview slug ->
      ({ model | selected=Just slug }, Cmd.none)
    DeselectReview ->
      ({ model | selected=Nothing }, Cmd.none)
    Content (ContentfulAPI.FetchBookReviews reviews) ->
      ({ model | reviews=reviews }, Cmd.none)
    _ ->
      (model, Cmd.none)

urlUpdate : Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  case route of
    Router.Review slug ->
      update (SelectReview slug) model
    _ ->
      update DeselectReview model

-- VIEW

view : Model -> Html Msg
view model =
  case model.selected of
    Just slug ->
      model.reviews
      |> List.filter (\review -> review.slug == slug)
      |> List.head
      |> Maybe.map viewOne
      |> Maybe.withDefault (text "No such review.")
    Nothing ->
      viewMany model.reviews

viewOne : BookReview.Model -> Html Msg
viewOne review =
  let fragment = Router.toFragment Router.BookReviews
  in
    div []
      [ a [class "back-button", href fragment] [text "Back to all reviews"]
      , BookReview.fullView review
      ]

viewMany : List BookReview.Model -> Html Msg
viewMany reviews =
  div [class "review-list"]
    [ h1 [] [text "Book Reviews"]
    , content reviews
    ]

content : List BookReview.Model -> Html Msg
content reviews =
  if List.isEmpty reviews then
    text "Loading Reviews"
  else
    div [] (List.map (reviewEntry) reviews)

reviewEntry : BookReview.Model -> Html Msg
reviewEntry review =
  let fragment = Router.toFragment (Router.Review review.slug)
  in
    a [class "review-entry", href fragment] [BookReview.compactView review]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
