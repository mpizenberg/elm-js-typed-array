module Filter exposing (..)

import Array.Hamt as Array exposing (Array)
import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Constants
import JsFloat64Array
import JsTypedArray
import JsUint8Array


main : BenchmarkProgram
main =
    program <|
        describe "Filter" <|
            [ lists
            , hamtArrays
            , uint8Arrays
            , float64Arrays
            ]


lists : Benchmark
lists =
    Constants.sizeScales
        |> List.map (\size -> ( size, List.repeat size 0 ))
        |> List.map (\( size, list ) -> ( toString size, \_ -> List.filter (\x -> x == 0) list ))
        |> scale "List"


hamtArrays : Benchmark
hamtArrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> Array.filter (\x -> x == 0) array ))
        |> scale "Hamt Array"


uint8Arrays : Benchmark
uint8Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsUint8Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> JsTypedArray.filter (\x -> x == 0) array ))
        |> scale "Uint8 Array"


float64Arrays : Benchmark
float64Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsFloat64Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> JsTypedArray.filter (\x -> x == 0) array ))
        |> scale "Float64 Array"
