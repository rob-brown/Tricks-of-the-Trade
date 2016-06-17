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
import Page

type Msg
  = FetchBookReviews (List BookReview.Model)
  | FetchBlogPosts (List BlogPost.Model)
  | FetchPages (List Page.Model)
  | FetchFail Http.Error

fetchBookReviews : ContentfulEndpoint.Page -> Cmd Msg
fetchBookReviews page =
  let
    url = ContentfulEndpoint.url (ContentfulEndpoint.BookReviews page)
    decoder = Json.at ["items"] (Json.list BookReview.decode)
  in
    Task.perform FetchFail FetchBookReviews (Http.get decoder url)

fetchBlogPosts : ContentfulEndpoint.Page -> Cmd Msg
fetchBlogPosts page =
  let
    url = ContentfulEndpoint.url (ContentfulEndpoint.BlogPosts page)
    decoder = Json.at ["items"] (Json.list BlogPost.decode)
  in
    Task.perform FetchFail FetchBlogPosts (Http.get decoder url)

fetchPages : ContentfulEndpoint.Page -> Cmd Msg
fetchPages page =
  let
    url = ContentfulEndpoint.url (ContentfulEndpoint.Pages page)
    decoder = Json.at ["items"] (Json.list Page.decode)
  in
    Task.perform FetchFail FetchPages (Http.get decoder url)
