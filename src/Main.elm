module Main exposing (main)

import Html.App as App
import BookReviewList
import BlogPostList
import Menu

main =
  App.program
    { init = Menu.init
    , view = Menu.view
    , update = Menu.update
    , subscriptions = Menu.subscriptions
    }

-- main =
--   App.program
--     { init = BlogPostList.init
--     , view = BlogPostList.view
--     , update = BlogPostList.update
--     , subscriptions = BlogPostList.subscriptions
--     }

-- main =
--   App.program
--     { init = BookReviewList.init
--     , view = BookReviewList.view
--     , update = BookReviewList.update
--     , subscriptions = BookReviewList.subscriptions
--     }
