module ContentfulAPI exposing
  ( Msg(FetchBookReviews, FetchBlogPosts, FetchPages, FetchFail)
  , fetchBookReviews
  , fetchBlogPosts
  , fetchPages
  )

import Json.Decode as Json
import Http
import Task
import ContentfulEndpoint
import BookReview
import BlogPost
import StaticPage

type Msg
  = FetchBookReviews (List BookReview.Model)
  | FetchBlogPosts (List BlogPost.Model)
  | FetchPages (List StaticPage.Model)
  | FetchFail Http.Error

fetchBookReviews : ContentfulEndpoint.Page -> Cmd Msg
fetchBookReviews page =
  let
    url = ContentfulEndpoint.url (ContentfulEndpoint.BookReviews page)
    decoder = Json.at ["items"] (Json.list BookReview.decode)
  in
    Http.get url decoder
    |> Http.toTask
    |> Task.attempt (\r ->
      case r of
        Ok reviews ->
          FetchBookReviews reviews
        Err e ->
          Debug.log ("API got error: " ++ (toString e))
          FetchFail e)

fetchBlogPosts : ContentfulEndpoint.Page -> Cmd Msg
fetchBlogPosts page =
  let
    url = ContentfulEndpoint.url (ContentfulEndpoint.BlogPosts page)
    decoder = Json.at ["items"] (Json.list BlogPost.decode)
  in
    Http.get url decoder
    |> Http.toTask
    |> Task.attempt (\r ->
      case r of
        Ok posts ->
          FetchBlogPosts posts
        Err e ->
          Debug.log ("API got error: " ++ (toString e))
          FetchFail e)

fetchPages : ContentfulEndpoint.Page -> Cmd Msg
fetchPages page =
  let
    url = ContentfulEndpoint.url (ContentfulEndpoint.Pages page)
    decoder = Json.at ["items"] (Json.list StaticPage.decode)
  in
    Http.get url decoder
    |> Http.toTask
    |> Task.attempt (\r ->
      case r of
        Ok pages ->
          FetchPages pages
        Err e ->
          Debug.log ("API got error: " ++ (toString e))
          FetchFail e)
