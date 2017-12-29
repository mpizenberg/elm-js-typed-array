module Creation0 exposing (..)

import Array.Hamt as Array
import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Constants
import JsFloat64Array
import JsUint8Array


main : BenchmarkProgram
main =
    program <|
        describe "Creation with zeros" <|
            [ lists
            , hamtArrays
            , uint8Arrays
            , float64Arrays
            ]


lists : Benchmark
lists =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> List.repeat size 0 ))
        |> scale "List"


hamtArrays : Benchmark
hamtArrays =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> Array.repeat size 0 ))
        |> scale "Hamt Array"


uint8Arrays : Benchmark
uint8Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> JsUint8Array.zeros size ))
        |> scale "Uint8 Typed Array"


float64Arrays : Benchmark
float64Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( toString size, \_ -> JsFloat64Array.zeros size ))
        |> scale "Float64 Typed Array"
