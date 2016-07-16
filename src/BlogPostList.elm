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
import PagableContent

-- MODEL

type alias Model = PagableContent.Model BlogPost.Model String

init : (Model, Cmd Msg)
init =
  let model = PagableContent.init [] Nothing viewOne viewMany .slug
  in
    (model, initialContent)

initialContent : Cmd Msg
initialContent =
  (ContentfulAPI.fetchBlogPosts 0)
  |> Cmd.map (\result ->
      case result of
        ContentfulAPI.FetchBlogPosts posts ->
          PagableContent.AddItems posts
        _ ->
          PagableContent.NoOp
    )

-- UPDATE

type alias Msg = PagableContent.Msg BlogPost.Model String

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  (PagableContent.update action model, Cmd.none)

urlUpdate : Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate route model =
  case route of
    Router.Post slug ->
      Debug.log ("Clicked blog post: " ++ slug)
      update (PagableContent.SelectItem slug) model
    _ ->
      update PagableContent.DeselectItem model

-- VIEW

view : Model -> Html Msg
view model =
  PagableContent.view model

viewOne : BlogPost.Model -> Html Msg
viewOne post =
  let fragment = Router.toFragment Router.Blog
  in
    div []
      [ a [class "back-button", href fragment] [text "Back to all posts"]
      , BlogPost.fullView post
      ]

viewMany : List BlogPost.Model -> Html Msg
viewMany posts =
  div [class "post-list"] [ content posts ]

content : List BlogPost.Model -> Html Msg
content posts =
  div [] (List.map postEntry posts)

postEntry : BlogPost.Model -> Html Msg
postEntry post =
  let fragment = Router.toFragment (Router.Post post.slug)
  in
    a [class "post-entry", href fragment] [BlogPost.compactView post]

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  PagableContent.subscriptions model
