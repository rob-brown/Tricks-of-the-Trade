module PagableContent exposing
  ( Model
  , Msg(NoOp, AddItems, SelectItem, DeselectItem, UpdateLoader)
  , init
  , view
  , update
  , subscriptions
  )

import Html exposing (Html)
import Kitt

-- MODEL

type alias Model a b =
  { items: List a
  , selected: Maybe b
  , loadingModel: Kitt.Model
  , viewOne: a -> Html (Msg a b)
  , viewMany: List a -> Html (Msg a b)
  , getId: a -> b
  }

init items selected viewOne viewMany getId =
  { items=items
  , selected=selected
  , loadingModel=Kitt.init
  , viewOne=viewOne
  , viewMany=viewMany
  , getId=getId
  }

-- VIEW

view model =
  if shouldShowLoadingView model then
    loadingView model
  else
    case model.selected of
      Just id ->
        model.items
        |> List.filter (\item -> (model.getId item) == id)
        |> List.head
        |> Maybe.map model.viewOne
        |> Maybe.withDefault (Html.text "No content found.")
      Nothing ->
        model.viewMany model.items

shouldShowLoadingView model =
  List.isEmpty model.items

loadingView model =
  Kitt.view model.loadingModel

-- UPDATE

type Msg a b
  = NoOp
  | AddItems (List a)
  | SelectItem b
  | DeselectItem
  | UpdateLoader Kitt.Msg

update : (Msg a b) -> (Model a b) -> (Model a b)
update action model =
  case action of
    NoOp ->
      model
    AddItems items ->
      let newItems = model.items ++ items
      in
        { model | items=newItems }
    SelectItem id ->
      { model | selected=Just id }
    DeselectItem ->
      { model | selected=Nothing }
    UpdateLoader subaction ->
      let loadingModel = Kitt.update subaction model.loadingModel
      in
        { model | loadingModel=loadingModel }

-- SUBSCRIPTIONS

subscriptions : (Model a b) -> Sub (Msg a b)
subscriptions model =
  if shouldShowLoadingView model then
    Sub.map UpdateLoader (Kitt.subscriptions model.loadingModel)
  else
    Sub.none
