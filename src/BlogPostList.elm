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
import MockData

-- MODEL

type alias Model =
  { posts: List BlogPost.Model
  , selected: Maybe BlogPost.Model
  , error: Maybe Http.Error
  }

init : (Model, Cmd Msg)
init =
  let
    posts = MockData.blogPosts
    model = { posts=posts, selected=Nothing, error=Nothing }
    command = Cmd.map Content (ContentfulAPI.fetchBlogPosts 0)
  in
    (model, command)

-- UPDATE

type Msg
  = Content ContentfulAPI.Msg
  | SelectPost BlogPost.Model
  | DeselectPost

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    SelectPost post ->
      ({ model | selected=Just post }, Cmd.none)
    DeselectPost ->
      ({ model | selected=Nothing }, Cmd.none)
    Content subaction ->
      case subaction of
        ContentfulAPI.FetchBlogPosts posts ->
          ({ model | posts=posts }, Cmd.none)
        ContentfulAPI.FetchFail error ->
          ({ model | error=Just error }, Cmd.none)
        _ ->
          (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  case model.selected of
    Just post ->
      viewOne post
    Nothing ->
      viewMany model.posts

viewOne : BlogPost.Model -> Html Msg
viewOne post =
  div []
    [ button [class "back-button", onClick DeselectPost] [text "Back to all posts"]
    , BlogPost.fullView post
    ]

viewMany : List BlogPost.Model -> Html Msg
viewMany posts =
  div [class "post-list"]
    [ h1 [] [text "Blog"]
    , content posts
    ]

content : List BlogPost.Model -> Html Msg
content posts =
  if List.isEmpty posts then
    text "Loading Blog Posts"
  else
    div [] (List.map postEntry posts)

postEntry : BlogPost.Model -> Html Msg
postEntry post =
  p [class "post-entry", onClick (SelectPost post)] [BlogPost.compactView post]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
