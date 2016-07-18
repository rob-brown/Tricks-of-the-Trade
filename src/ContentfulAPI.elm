module ContentfulAPI exposing
  ( Msg(FetchBookReviews, FetchBlogPosts, FetchPages, FetchPresentations, FetchFail)
  , fetchBookReviews
  , fetchBlogPosts
  , fetchPresentations
  , fetchPages
  )

import Json.Decode as Json
import Http
import Task
import ContentfulEndpoint
import BookReview
import BlogPost
import StaticPage
import Presentation

type Msg
  = FetchBookReviews (List BookReview.Model)
  | FetchBlogPosts (List BlogPost.Model)
  | FetchPages (List StaticPage.Model)
  | FetchPresentations (List Presentation.Model)
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
    decoder = Json.at ["items"] (Json.list StaticPage.decode)
  in
    Task.perform FetchFail FetchPages (Http.get decoder url)

fetchPresentations : ContentfulEndpoint.Page -> Cmd Msg
fetchPresentations page =
  let
    url = ContentfulEndpoint.url (ContentfulEndpoint.Presentations page)
    decoder = Json.at ["items"] (Json.list Presentation.decode)
  in
    Task.perform FetchFail FetchPresentations (Http.get decoder url)
