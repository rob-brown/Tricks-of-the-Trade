module Menu exposing
  ( MenuItem(BlogPosts, BookReviews, Other)
  , Model
  , init
  , update
  , view
  , subscriptions
  )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page
import BookReviewList
import BlogPostList
import Array exposing (Array)

-- MODEL

type MenuItem
  = BlogPosts BlogPostList.Model
  | BookReviews BookReviewList.Model
  | Other Page.Model

type alias Model =
  { posts: BlogPostList.Model
  , reviews: BookReviewList.Model
  , current: Int
  }

init : (Model, Cmd Msg)
init =
  let
    (posts, postsCmd) = BlogPostList.init
    (reviews, reviewsCmd) = BookReviewList.init
    commands = [Cmd.map UpdateBlog postsCmd, Cmd.map UpdateBookReviews reviewsCmd]
    model = { posts=posts, reviews=reviews, current=0 }
  in
    (model, Cmd.batch commands)

-- UPDATE

type Msg
  = SelectItem Int
  | UpdateBlog BlogPostList.Msg
  | UpdateBookReviews BookReviewList.Msg

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

-- VIEW

view : Model -> Html Msg
view model =
  let tabViews = List.indexedMap (tabView model.current) (tabs model)
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
      BlogPostList.view posts
    BookReviews reviews ->
      BookReviewList.view reviews
    Other page ->
      Page.view page

tabs : Model -> List MenuItem
tabs model =
  [BlogPosts model.posts, BookReviews model.reviews]

tabView : Int -> Int -> MenuItem -> Html Msg
tabView selected index item =
  li [onClick (SelectItem index)] [text (tabTitle item)]

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
