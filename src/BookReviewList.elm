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
    SelectReview id ->
      ({ model | selected=Just id }, Cmd.none)
    DeselectReview ->
      ({ model | selected=Nothing }, Cmd.none)
    Content (ContentfulAPI.FetchBookReviews reviews) ->
      ({ model | reviews=reviews }, Cmd.none)
    _ ->
      (model, Cmd.none)

urlUpdate : Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  case route of
    Router.Review id ->
      update (SelectReview id) model
    _ ->
      update DeselectReview model

-- VIEW

view : Model -> Html Msg
view model =
  case model.selected of
    Just id ->
      model.reviews
      |> List.filter (\review -> review.id == id)
      |> List.head
      |> Maybe.map viewOne
      |> Maybe.withDefault (text "No such review.")
    Nothing ->
      viewMany model.reviews

viewOne : BookReview.Model -> Html Msg
viewOne review =
  div []
    [ a [class "back-button", href (Router.toFragment Router.BookReviews)] [text "Back to all reviews"]
    , BookReview.fullView review
    ]

viewMany : List BookReview.Model -> Html Msg
viewMany reviews =
  div []
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
  a [class "review-entry", href (Router.toFragment (Router.Review review.id))] [BookReview.compactView review]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
