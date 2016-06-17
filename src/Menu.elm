module Menu exposing
  ( MenuItem(BlogPosts, BookReviews, Other)
  , Model
  , init
  , update
  , view
  , subscriptions
  )

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array exposing (Array)
import Page
import BookReviewList
import BlogPostList
import ContentfulAPI
import MockData

-- MODEL

type MenuItem
  = BlogPosts BlogPostList.Model
  | BookReviews BookReviewList.Model
  | Other Page.Model

type alias Model =
  { posts: BlogPostList.Model
  , reviews: BookReviewList.Model
  , pages: List Page.Model
  , current: Int
  }

init : (Model, Cmd Msg)
init =
  let
    (posts, postsCmd) = BlogPostList.init
    (reviews, reviewsCmd) = BookReviewList.init
    model = { posts=posts, reviews=reviews, pages=MockData.pages, current=0 }
    commands =
      [ Cmd.map UpdateBlog postsCmd
      , Cmd.map UpdateBookReviews reviewsCmd
      , Cmd.map Content (ContentfulAPI.fetchPages 0)
      ]
  in
    (model, Cmd.batch commands)

-- UPDATE

type Msg
  = SelectItem Int
  | UpdateBlog BlogPostList.Msg
  | UpdateBookReviews BookReviewList.Msg
  | Content ContentfulAPI.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    SelectItem index ->
      ({ model | current=index }, Cmd.none)
    UpdateBlog subaction ->
      let (posts, command) = BlogPostList.update subaction model.posts
      in
        ({ model | posts=posts }, Cmd.map UpdateBlog command)
    UpdateBookReviews subaction ->
      let (reviews, command) = BookReviewList.update subaction model.reviews
      in
        ({ model | reviews=reviews }, Cmd.map UpdateBookReviews command)
    Content subaction ->
      case subaction of
        ContentfulAPI.FetchPages pages ->
          ({ model | pages=pages }, Cmd.none)
        _ ->
          (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  let
    tabViews =
      [li [id "site-title"] [text "Tricks of the Trade"]]
      ++ (List.indexedMap (tabView model.current) (tabs model))
  in
    div []
      [ header [] [div [id "menu"] [ul [] tabViews]]
      , div [id "main"] [content model]
      ]

content : Model -> Html Msg
content model =
  model
  |> tabs
  |> Array.fromList
  |> Array.get model.current
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
      Page.view page

tabs : Model -> List MenuItem
tabs model =
  [BlogPosts model.posts, BookReviews model.reviews] ++ List.map Other model.pages

tabView : Int -> Int -> MenuItem -> Html Msg
tabView selected index item =
  li
    [ onClick (SelectItem index)
    , classList [("menu-item", True), ("selected", selected == index)]
    ]
    [text (tabTitle item)]

tabTitle : MenuItem -> String
tabTitle item =
  case item of
    BlogPosts _ ->
      "Blog"
    BookReviews _ ->
      "Book Reviews"
    Other page ->
      page.title

-- SUBSCRIPTION

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
