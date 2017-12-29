module Constants exposing (..)


sizeScales : List Int
sizeScales =
    List.range 1 3
        |> List.map ((^) 10)
