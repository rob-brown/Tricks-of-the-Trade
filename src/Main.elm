module Main exposing (main)

import Menu
import Router
import Navigation

main =
  Navigation.program Menu.UrlChange
    { init = Menu.init
    , view = Menu.view
    , update = Menu.update
    , subscriptions = Menu.subscriptions
    }
