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

import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Task
import BookReview
import ContentfulAPI
import Router
import PagableContent

-- MODEL

type alias Model = PagableContent.Model BookReview.Model String

init : (Model, Cmd Msg)
init =
  let model = PagableContent.init [] Nothing viewOne viewMany .slug
  in
    (model, initialContent)

initialContent : Cmd Msg
initialContent =
  (ContentfulAPI.fetchBookReviews 0)
  |> Cmd.map (\result ->
      case result of
        ContentfulAPI.FetchBookReviews reviews ->
          PagableContent.AddItems reviews
        _ ->
          PagableContent.NoOp
    )

-- UPDATE

type alias Msg = PagableContent.Msg BookReview.Model String

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  (PagableContent.update action model, Cmd.none)

urlUpdate : Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  case route of
    Router.Review slug ->
      Debug.log ("Clicked book review: " ++ slug)
      update (PagableContent.SelectItem slug) model
    _ ->
      update PagableContent.DeselectItem model

-- VIEW

view : Model -> Html Msg
view model =
  PagableContent.view model

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
  div [class "review-list"] [ content reviews ]

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
  PagableContent.subscriptions model
