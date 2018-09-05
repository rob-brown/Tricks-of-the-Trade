module ContentfulEndpoint exposing
  ( Endpoint(BookReviews, OneBookReview, BlogPosts, OneBlogPost, Pages, OnePage)
  , ID
  , Page
  , url
  )

import Uri

type alias ID = String
type alias Page = Int

type Endpoint
  = BookReviews Page
  | OneBookReview ID Page
  | BlogPosts Page
  | OneBlogPost ID Page
  | Pages Page
  | OnePage ID Page

url : Endpoint -> String
url endpoint =
  let
    accessToken = "59c5f3c65a74a97ab3f9e5fc5e27d650cc27ca2d1edc6e07347ddc8cb057d4c9"
    (path, params) = urlInfo endpoint
  in
    Uri.build "https" host path params

host : String
host =
    "cdn.contentful.com"

limit : String
limit =
  "100"

urlInfo : Endpoint -> (String, List (String, String))
urlInfo endpoint =
  let
    spaceID = "fj45bzul2z16"
    accessToken = "59c5f3c65a74a97ab3f9e5fc5e27d650cc27ca2d1edc6e07347ddc8cb057d4c9"
  in
    case endpoint of
      BookReviews page ->
        ( Uri.path ["spaces", spaceID, "entries"]
        , [( "access_token", accessToken)
           , ("content_type", "bookReview")
           , ("order", "fields.bookTitle")
           , ("limit", limit)
           , ("skip", (toString page))
           ]
        )
      OneBookReview id page ->
        ( Uri.path ["spaces", spaceID, "entries", id]
        , [( "access_token", accessToken)
           , ("content_type", "bookReview")
           , ("limit", limit)
           , ("skip", (toString page))
           ]
        )
      BlogPosts page ->
        ( Uri.path ["spaces", spaceID, "entries"]
        , [( "access_token", accessToken)
           , ("content_type", "blogPost")
           , ("order", "-fields.date")
           , ("limit", limit)
           , ("skip", (toString page))
           ]
        )
      OneBlogPost id page ->
        ( Uri.path ["spaces", spaceID, "entries", id]
        , [( "access_token", accessToken)
           , ("content_type", "blogPost")
           , ("limit", limit)
           , ("skip", (toString page))
           ]
        )
      Pages page ->
        ( Uri.path ["spaces", spaceID, "entries"]
        , [( "access_token", accessToken)
           , ("content_type", "page")
           , ("order", "fields.order")
           , ("limit", limit)
           , ("skip", (toString page))
           ]
        )
      OnePage id page ->
        ( Uri.path ["spaces", spaceID, "entries", id]
        , [( "access_token", accessToken)
           , ("content_type", "page")
           , ("limit", limit)
           , ("skip", (toString page))
           ]
        )
