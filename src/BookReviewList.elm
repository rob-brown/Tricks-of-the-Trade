module BookReviewList exposing
  ( Model
  , Msg
  , init
  , view
  , update
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
import MockData

-- MODEL

type alias Model =
  { reviews: List BookReview.Model
  , selected: Maybe BookReview.Model
  , error: Maybe Http.Error
  }

init : (Model, Cmd Msg)
init =
  let
    reviews = MockData.bookReviews
    model = { reviews=reviews, selected=Nothing, error=Nothing }
    command = Cmd.map Content (ContentfulAPI.fetchBookReviews 0)
  in
    (model, command)

-- UPDATE

type Msg
  = Content ContentfulAPI.Msg
  | SelectReview BookReview.Model
  | DeselectReview

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    SelectReview review ->
      ({ model | selected=Just review }, Cmd.none)
    DeselectReview ->
      ({ model | selected=Nothing }, Cmd.none)
    Content subaction ->
      case subaction of
        ContentfulAPI.FetchBookReviews reviews ->
          ({ model | reviews=reviews }, Cmd.none)
        ContentfulAPI.FetchFail error ->
          ({ model | error=Just error }, Cmd.none)
        _ ->
          (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  case model.selected of
    Just review ->
      viewOne review
    Nothing ->
      viewMany model.reviews

viewOne : BookReview.Model -> Html Msg
viewOne review =
  div []
    [ button [class "back-button", onClick DeselectReview] [text "Back to all reviews"]
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
    div [] (List.map reviewEntry reviews)

reviewEntry : BookReview.Model -> Html Msg
reviewEntry review =
  p [class "review-entry", onClick (SelectReview review)] [BookReview.compactView review]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
