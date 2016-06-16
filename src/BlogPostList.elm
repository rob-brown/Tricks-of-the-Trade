module BlogPostList exposing
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
import BlogPost
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
  { posts: List BlogPost.Model
  , error: Maybe Http.Error
  }

init : (Model, Cmd Msg)
init =
  let
    model = { posts = [], error = Nothing }
    command = Cmd.map Content (ContentfulAPI.fetchBlogPosts 0)
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
          (model, Cmd.none)
        ContentfulAPI.FetchBlogPosts posts ->
          ({ model | posts=posts }, Cmd.none)
        ContentfulAPI.FetchFail error ->
          ({ model | error=Just error }, Cmd.none)

-- VIEW

-- view : Model -> Html Msg
view : Model -> Html a
view model =
  div []
    [ h1 [] [text "Blog"]
    , content model
    ]

-- content : Model -> Html Msg
content : Model -> Html a
content model =
  if List.isEmpty model.posts then
    text "Loading Blog Posts"
  else
    div [] (List.map BlogPost.fullView model.posts)

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
