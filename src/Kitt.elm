module Kitt exposing
  ( Model
  , Msg
  , init
  , update
  , view
  , subscriptions
  )

import Html exposing (Html)
import Html.App
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Array exposing (Array)
import Color exposing (Color)
import String

main =
  Html.App.program
    { init=(init, Cmd.none)
    , update=(\a m -> (update a m, Cmd.none))
    , view=view
    , subscriptions=subscriptions
    }

-- MODEL

type alias Model = { frameIndex: Int, width: Int, height: Int }

type alias Frame = List Float

init : Model
init =
  { frameIndex=0
  , width=700
  , height=200
  }

defaultFrame : Frame
defaultFrame =
  [0, 0, 0, 0, 0, 0, 0, 0]

frames : Array Frame
frames =
  Array.fromList
    [ [0,    0,    0,    0,    0,    0,    0,    0]
    , [1,    0,    0,    0,    0,    0,    0,    0]
    , [0.5,  1,    0,    0,    0,    0,    0,    0]
    , [0.25, 0.5,  1,    0,    0,    0,    0,    0]
    , [0,    0.25, 0.5,  1,    0,    0,    0,    0]
    , [0,    0,    0.25, 0.5,  1,    0,    0,    0]
    , [0,    0,    0,    0.25, 0.5,  1,    0,    0]
    , [0,    0,    0,    0,    0.25, 0.5,  1,    0]
    , [0,    0,    0,    0,    0,    0.25, 0.5,  1]
    , [0,    0,    0,    0,    0,    0,    1,    0.5]
    , [0,    0,    0,    0,    0,    1,    0.5,  0.25]
    , [0,    0,    0,    0,    1,    0.5,  0.25, 0]
    , [0,    0,    0,    1,    0.5,  0.25, 0,    0]
    , [0,    0,    1,    0.5,  0.25, 0,    0,    0]
    , [0,    1,    0.5,  0.25, 0,    0,    0,    0]
    , [1,    0.5,  0.25, 0,    0,    0,    0,    0]
    , [0.5,  0.25, 0,    0,    0,    0,    0,    0]
    , [0.25, 0,    0,    0,    0,    0,    0,    0]
    , [0,    0,    0,    0,    0,    0,    0,    0]
    , [0,    0,    0,    0,    0,    0,    0,    0]
    , [0,    0,    0,    0,    0,    0,    0,    0]
    , [0,    0,    0,    0,    0,    0,    0,    0]
    ]

frameCount : Int
frameCount =
  Array.length frames

frameSize : Int
frameSize =
  List.length defaultFrame

-- VIEW

view : Model -> Html a
view model =
  Html.div [class "kitt"] [ segments model ]

segments : Model -> Svg a
segments model =
  let
    w = 30
    h = 20
    frame = Maybe.withDefault defaultFrame (Array.get model.frameIndex frames)
    count = List.length frame
    frameWidth = toString model.width
    frameHeight = toString model.height
    box = String.concat ["0 0 ", frameWidth, " ", frameHeight]
    segs = List.indexedMap (segment model w h) frame
  in
    svg
      [ width frameWidth
      , height frameHeight
      , viewBox box
      ]
      segs

segment : Model -> Int -> Int -> Int -> Float -> Svg a
segment model w h i s =
  let
    c = Color.hsla (degrees 240) 1 0.5 s
    color = colorString c
    segsWidth = frameSize * w
    xCoord = model.width // 2 - segsWidth // 2 + w * i
    yCoord = model.height // 2 - h // 2
  in
    rect
      [ x (toString xCoord)
      , y (toString yCoord)
      , width (toString w)
      , height (toString h)
      , fill color
      --, stroke "Black"
      ]
      []

-- UPDATE

type Msg = Tick Time

update : Msg -> Model -> Model
update action model =
  case action of
    Tick _ ->
      let nextFrame = (model.frameIndex + 1) % frameCount
      in
        { model | frameIndex=nextFrame }

-- SUBSCRIPTIONS

animationDuration : Time
animationDuration =
  1.5 * second

refreshRate : Time
refreshRate =
  animationDuration / (toFloat frameCount)

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every refreshRate Tick

-- HELPERS

colorString : Color -> String
colorString color =
  let
    { red, green, blue, alpha} = Color.toRgb color
    r = toString red
    g = toString green
    b = toString blue
    a = toString alpha
    rgba = String.join "," [r, g, b, a]
  in
    String.concat ["rgba(", rgba, ")"]
