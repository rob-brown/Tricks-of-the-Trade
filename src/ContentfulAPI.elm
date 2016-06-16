module ContentfulAPI exposing
  ( Msg(FetchBookReviews, FetchBlogPosts, FetchFail)
  , fetchBookReviews
  , fetchBlogPosts
  )

import Http
import Json.Decode as Json
import ContentfulEndpoint
import BookReview
import BlogPost
import Task

type Msg
  = FetchBookReviews (List BookReview.Model)
  | FetchBlogPosts (List BlogPost.Model)
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
