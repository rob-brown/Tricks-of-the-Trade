module BlogPostList exposing
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
import BlogPost
import ContentfulAPI
import Router
import MockData

-- MODEL

type alias Model =
  { posts: List BlogPost.Model
  , selected: Maybe String
  }

init : (Model, Cmd Msg)
init =
  let
    posts = MockData.blogPosts
    model = { posts=posts, selected=Nothing }
    command = Cmd.map Content (ContentfulAPI.fetchBlogPosts 0)
  in
    (model, command)

-- UPDATE

type Msg
  = Content ContentfulAPI.Msg
  | SelectPost String
  | DeselectPost

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    SelectPost id ->
      ({ model | selected=Just id }, Cmd.none)
    DeselectPost ->
      ({ model | selected=Nothing }, Cmd.none)
    Content (ContentfulAPI.FetchBlogPosts posts) ->
      ({ model | posts=posts }, Cmd.none)
    _ ->
      (model, Cmd.none)

urlUpdate : Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  case route of
    Router.Post id ->
      Debug.log ("Clicked blog post: " ++ id)
      update (SelectPost id) model
    _ ->
      update DeselectPost model

-- VIEW

view : Model -> Html Msg
view model =
  case model.selected of
    Just id ->
      model.posts
      |> List.filter (\post -> post.id == id)
      |> List.head
      |> Maybe.map viewOne
      |> Maybe.withDefault (text "No such post.")
    Nothing ->
      viewMany model.posts

viewOne : BlogPost.Model -> Html Msg
viewOne post =
  div []
    [ a [class "back-button", href (Router.toFragment Router.Blog)] [text "Back to all posts"]
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
  a
    [ class "post-entry"
    , href (Router.toFragment (Router.Post post.id))
    ]
    [BlogPost.compactView post]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
