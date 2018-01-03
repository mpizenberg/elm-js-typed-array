module EqualWorstCase exposing (..)

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
        describe "Equal (worst case: all equals)" <|
            [ lists
            , hamtArrays
            , uint8Arrays
            , float64Arrays
            ]


lists : Benchmark
lists =
    Constants.sizeScales
        |> List.map (\size -> ( size, List.repeat size 0, List.repeat size 0 ))
        |> List.map (\( size, list1, list2 ) -> ( toString size, \_ -> list1 == list2 ))
        |> scale "List"


hamtArrays : Benchmark
hamtArrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, Array.repeat size 0, Array.repeat size 0 ))
        |> List.map (\( size, array1, array2 ) -> ( toString size, \_ -> array1 == array2 ))
        |> scale "Hamt Array"


uint8Arrays : Benchmark
uint8Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsUint8Array.repeat size 0, JsUint8Array.repeat size 0 ))
        |> List.map (\( size, array1, array2 ) -> ( toString size, \_ -> JsTypedArray.equal array1 array2 ))
        |> scale "Uint8 Array"


float64Arrays : Benchmark
float64Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsFloat64Array.repeat size 0, JsFloat64Array.repeat size 0 ))
        |> List.map (\( size, array1, array2 ) -> ( toString size, \_ -> JsTypedArray.equal array1 array2 ))
        |> scale "Float64 Array"
