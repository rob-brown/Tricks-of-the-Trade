module Main exposing (main)

import Menu
import Router
import Navigation

main =
  Navigation.program (Navigation.makeParser Router.fragmentParser)
    { init = Menu.init
    , view = Menu.view
    , update = Menu.update
    , urlUpdate = Menu.urlUpdate
    , subscriptions = Menu.subscriptions
    }
