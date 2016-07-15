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
import Kitt

-- MODEL

type alias Model =
  { posts: List BlogPost.Model
  , selected: Maybe String
  , loadingModel: Kitt.Model
  }

init : (Model, Cmd Msg)
init =
  let
    posts = []
    model = { posts=posts, selected=Nothing, loadingModel=Kitt.init }
    command = Cmd.map Content (ContentfulAPI.fetchBlogPosts 0)
  in
    (model, command)

-- UPDATE

type Msg
  = Content ContentfulAPI.Msg
  | SelectPost String
  | DeselectPost
  | UpdateLoader Kitt.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    SelectPost slug ->
      ({ model | selected=Just slug }, Cmd.none)
    DeselectPost ->
      ({ model | selected=Nothing }, Cmd.none)
    Content (ContentfulAPI.FetchBlogPosts posts) ->
      ({ model | posts=posts }, Cmd.none)
    UpdateLoader subaction ->
      let loadingModel = Kitt.update subaction model.loadingModel
      in
        ({ model | loadingModel=loadingModel }, Cmd.none)
    _ ->
      (model, Cmd.none)

urlUpdate : Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  case route of
    Router.Post slug ->
      Debug.log ("Clicked blog post: " ++ slug)
      update (SelectPost slug) model
    _ ->
      update DeselectPost model

-- VIEW

view : Model -> Html Msg
view model =
  case model.selected of
    Just slug ->
      model.posts
      |> List.filter (\post -> post.slug == slug)
      |> List.head
      |> Maybe.map viewOne
      |> Maybe.withDefault (text "No such post.")
    Nothing ->
      viewMany model

viewOne : BlogPost.Model -> Html Msg
viewOne post =
  let fragment = Router.toFragment Router.Blog
  in
    div []
      [ a [class "back-button", href fragment] [text "Back to all posts"]
      , BlogPost.fullView post
      ]

viewMany : Model -> Html Msg
viewMany model =
  div [class "post-list"] [ content model ]

content : Model -> Html Msg
content model =
  if showLoadingView model then
    loadingView model
  else
    div [] (List.map postEntry model.posts)

showLoadingView : Model -> Bool
showLoadingView model =
  List.isEmpty model.posts

loadingView : Model -> Html Msg
loadingView model =
  Kitt.view model.loadingModel

postEntry : BlogPost.Model -> Html Msg
postEntry post =
  let fragment = Router.toFragment (Router.Post post.slug)
  in
    a [class "post-entry", href fragment] [BlogPost.compactView post]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  if showLoadingView model then
    Sub.map UpdateLoader (Kitt.subscriptions model.loadingModel)
  else
    Sub.none
