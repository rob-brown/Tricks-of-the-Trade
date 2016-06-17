module MockData exposing (..)

import BlogPost
import BookReview

blogPosts : List BlogPost.Model
blogPosts =
  [ BlogPost.Model "1" "Blog Post 1" (Just "Just a test") "This is a test, it is only a test." "2016-06-12T10:18-06:00"
  , BlogPost.Model "2" "Blog Post 2" (Just "Just a test") "This is a test, it is only a test." "2016-06-12T10:18-06:00"
  , BlogPost.Model "3" "Blog Post 3" (Just "Just a test") "This is a test, it is only a test." "2016-06-12T10:18-06:00"
  , BlogPost.Model "4" "Blog Post 4" (Just "Just a test") "This is a test, it is only a test." "2016-06-12T10:18-06:00"
  , BlogPost.Model "5" "Blog Post 5" (Just "Just a test") "This is a test, it is only a test." "2016-06-12T10:18-06:00"
  , BlogPost.Model "6" "Blog Post 6" (Just "Just a test") "This is a test, it is only a test." "2016-06-12T10:18-06:00"
  , BlogPost.Model "7" "Blog Post 7" (Just "Just a test") "This is a test, it is only a test." "2016-06-12T10:18-06:00"
  ]

bookReviews : List BookReview.Model
bookReviews =
  [ BookReview.Model "1" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  , BookReview.Model "2" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  , BookReview.Model "3" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  , BookReview.Model "4" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  , BookReview.Model "5" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  , BookReview.Model "6" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  , BookReview.Model "7" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  , BookReview.Model "8" "Some Book" (Just "A witty subtitle") "Billy Bob" "http://www.amazon.com" "This is a great book; read it."
  ]
