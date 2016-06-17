module Main exposing (main)

import Html.App as App
import Menu

main =
  App.program
    { init = Menu.init
    , view = Menu.view
    , update = Menu.update
    , subscriptions = Menu.subscriptions
    }
