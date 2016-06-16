module Uri exposing (build, path)

import String

build : String -> String -> String -> List (String, String) -> String
build scheme host path params =
  let
    paramString = params
    |> List.map (\(k, v) -> k ++ "=" ++ v)
    |> String.join "&"
  in
    scheme ++ "://" ++ host ++ path ++ "?" ++ paramString

path : List String -> String
path components =
  "/" ++ String.join "/" components
