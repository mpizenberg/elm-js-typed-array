module CreationInit exposing (..)

import Array.Hamt as Array
import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Constants
import JsFloat64Array
import JsUint8Array


main : BenchmarkProgram
main =
    program <|
        describe "Creation with init function" <|
            [ lists
            , hamtArrays
            , uint8Arrays
            , float64Arrays
            ]


initializeList : Int -> (Int -> a) -> List a
initializeList length f =
    let
        helper n list =
            case n of
                (-1) ->
                    list

                _ ->
                    helper (n - 1) (f n :: list)
    in
    helper (length - 1) []


lists : Benchmark
lists =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> initializeList size (\n -> n) ))
        |> scale "List"


hamtArrays : Benchmark
hamtArrays =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> Array.initialize size (\n -> n) ))
        |> scale "Hamt Array"


uint8Arrays : Benchmark
uint8Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> JsUint8Array.initialize size (\n -> n) ))
        |> scale "Uint8 Typed Array"


float64Arrays : Benchmark
float64Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> JsFloat64Array.initialize size (\n -> toFloat n) ))
        |> scale "Float64 Typed Array"
