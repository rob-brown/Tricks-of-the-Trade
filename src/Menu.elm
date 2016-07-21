module Menu exposing
  ( MenuItem(BlogPosts, BookReviews, Other)
  , Model
  , init
  , update
  , urlUpdate
  , view
  , subscriptions
  )

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation
import StaticPage
import BookReviewList
import BlogPostList
import ContentfulAPI
import Router

-- MODEL

type MenuItem
  = BlogPosts BlogPostList.Model
  | BookReviews BookReviewList.Model
  | Other StaticPage.Model

type alias Model =
  { posts: BlogPostList.Model
  , reviews: BookReviewList.Model
  , pages: List StaticPage.Model
  , route: Router.Route
  }

init : Result String Router.Route -> (Model, Cmd Msg)
init result =
  let
    (posts, postsCmd) = BlogPostList.init
    (reviews, reviewsCmd) = BookReviewList.init
    initialModel = { posts=posts, reviews=reviews, pages=[], route=Router.Home }
    (model, urlCommands) = urlUpdate result initialModel
    commands =
      [ Cmd.map UpdateBlog postsCmd
      , Cmd.map UpdateBookReviews reviewsCmd
      , Cmd.map Content (ContentfulAPI.fetchPages 0)
      , urlCommands
      ]
  in
    (model, Cmd.batch commands)

-- UPDATE

type Msg
  = SelectItem Router.Route
  | UpdateBlog BlogPostList.Msg
  | UpdateBookReviews BookReviewList.Msg
  | Content ContentfulAPI.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    SelectItem route ->
      ({ model | route=route }, Cmd.none)
    UpdateBlog subaction ->
      let (posts, command) = BlogPostList.update subaction model.posts
      in
        ({ model | posts=posts }, Cmd.map UpdateBlog command)
    UpdateBookReviews subaction ->
      let (reviews, command) = BookReviewList.update subaction model.reviews
      in
        ({ model | reviews=reviews }, Cmd.map UpdateBookReviews command)
    Content (ContentfulAPI.FetchPages pages) ->
      ({ model | pages=pages }, Cmd.none)
    _ ->
      (model, Cmd.none)

urlUpdate : Result String Router.Route -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case result of
    Err error ->
      Debug.log ("Routing error: " ++ (toString error))
      (model, Navigation.modifyUrl (Router.toFragment model.route))
    Ok route ->
      let
        (posts, postsCmd) = BlogPostList.urlUpdate route model.posts
        (reviews, reviewsCmd) = BookReviewList.urlUpdate route model.reviews
        commands = [Cmd.map UpdateBlog postsCmd, Cmd.map UpdateBookReviews reviewsCmd]
      in
        ({ model | posts=posts, reviews=reviews, route=route }, Cmd.batch commands)

-- VIEW

view : Model -> Html Msg
view model =
  let tabViews = (List.map (tabView model.route) (tabs model))
  in
    div []
      [ header []
        [ div [id "site-title"] [h1 [] [text "Tricks of the Trade"]]
        , div [id "menu"] [ul [] tabViews]]
      , div [id "main"] [content model]
      ]

content : Model -> Html Msg
content model =
  model
  |> tabs
  |> List.filter (isSelected model.route)
  |> List.head
  |> Maybe.map contentView
  |> Maybe.withDefault (text "Missing Content")

contentView : MenuItem -> Html Msg
contentView item =
  case item of
    BlogPosts posts ->
      App.map UpdateBlog (BlogPostList.view posts)
    BookReviews reviews ->
      App.map UpdateBookReviews (BookReviewList.view reviews)
    Other page ->
      StaticPage.view page

tabs : Model -> List MenuItem
tabs model =
  [BlogPosts model.posts, BookReviews model.reviews] ++ List.map Other model.pages

tabView : Router.Route -> MenuItem -> Html Msg
tabView route item =
  let
    classes = classList
      [ ("menu-item", True)
      , ("selected", (isSelected route item))
      ]
  in
    case item of
      BlogPosts _ ->
        li [] [a [href (Router.toFragment Router.Blog), classes] [text "Blog"]]
      BookReviews _ ->
        li [] [a [href (Router.toFragment Router.BookReviews), classes] [text "Bookshelf"]]
      Other page ->
        li [] [a [href (Router.toFragment (Router.Page page.slug)), classes] [text page.title]]

isSelected : Router.Route -> MenuItem -> Bool
isSelected route item =
  case (route, item) of
    (Router.Home, BlogPosts _) ->
      True
    (Router.Blog, BlogPosts _) ->
      True
    (Router.Post _, BlogPosts _) ->
      True
    (Router.BookReviews, BookReviews _) ->
      True
    (Router.Review _, BookReviews _) ->
      True
    (Router.Page slug, Other page) ->
      page.slug == slug
    _ ->
      False

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  let
    blogSubs = Sub.map UpdateBlog (BlogPostList.subscriptions model.posts)
    reviewSubs = Sub.map UpdateBookReviews (BookReviewList.subscriptions model.reviews)
  in
    Sub.batch [blogSubs, reviewSubs]
