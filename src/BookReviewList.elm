module BookReviewList exposing
  ( Model
  , Msg
  , main
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

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { reviews: List BookReview.Model
  , error: Maybe Http.Error
  }

init : (Model, Cmd Msg)
init =
  let
    model = { reviews = [], error = Nothing }
    command = Cmd.map Content (ContentfulAPI.fetchBookReviews 0)
  in
    (model, command)

-- UPDATE

type Msg
  = Content ContentfulAPI.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Content subaction ->
      case subaction of
        ContentfulAPI.FetchBookReviews reviews ->
          ({ model | reviews=reviews }, Cmd.none)
        ContentfulAPI.FetchBlogPosts _ ->
          (model, Cmd.none)
        ContentfulAPI.FetchFail error ->
          ({ model | error=Just error }, Cmd.none)

-- VIEW

-- view : Model -> Html Msg
view : Model -> Html a
view model =
  div []
    [ h1 [] [text "Book Reviews"]
    , content model
    --, text (toString model.error)
    ]

-- content : Model -> Html Msg
content : Model -> Html a
content model =
  if List.isEmpty model.reviews then
    text "Loading Reviews"
  else
    div [] (List.map BookReview.fullView model.reviews)

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
