module Foldr exposing (..)

import Array.Hamt as Array
import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Constants
import JsFloat64Array
import JsTypedArray
import JsUint8Array


main : BenchmarkProgram
main =
    program <|
        describe "Fold right" <|
            [ lists
            , hamtArrays
            , uint8Arrays
            , float64Arrays
            ]


lists : Benchmark
lists =
    Constants.sizeScales
        |> List.map (\size -> ( size, List.range 0 (size - 1) ))
        |> List.map (\( size, list ) -> ( toString size, \_ -> List.foldr (\x acc -> x + acc) 0 list ))
        |> scale "List"


hamtArrays : Benchmark
hamtArrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, Array.initialize size identity ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> Array.foldr (\x acc -> x + acc) 0 array ))
        |> scale "Hamt Array"


uint8Arrays : Benchmark
uint8Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsUint8Array.initialize size identity ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> JsTypedArray.foldr (\x acc -> x + acc) 0 array ))
        |> scale "Uint8 Array"


float64Arrays : Benchmark
float64Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsFloat64Array.initialize size (\id -> toFloat id) ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> JsTypedArray.foldr (\x acc -> x + acc) 0 array ))
        |> scale "Float64 Array"
