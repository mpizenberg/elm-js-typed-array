module Test exposing (..)

import Array.Hamt as Array
import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Constants
import JsFloat64Array
import JsTypedArray
import JsUint8Array


main : BenchmarkProgram
main =
    program suite


list =
    List.range 0 9999
        |> List.map (flip (%) (10000 // 3))


hamtArray =
    Array.initialize 10000 (\id -> id % (10000 // 3))


uint8Array =
    JsUint8Array.initialize 10000
        |> JsTypedArray.indexedMap (\id _ -> id % (10000 // 3))


float64Array =
    JsFloat64Array.initialize 10000
        |> JsTypedArray.indexedMap (\id _ -> toFloat <| id % (10000 // 3))


suite : Benchmark
suite =
    describe "Extract first half" <|
        [ benchmark "List" <|
            \_ ->
                List.take 5000 list
        , benchmark "Hamt Array 0 5000" <|
            \_ ->
                Array.slice 0 5000 hamtArray
        , benchmark "Hamt Array 0 5007" <|
            \_ ->
                Array.slice 0 5007 hamtArray
        , benchmark "Hamt Array 1000 6000" <|
            \_ ->
                Array.slice 1000 6000 hamtArray
        , benchmark "Uint8 Array" <|
            \_ ->
                JsTypedArray.extract 0 5000 uint8Array
        , benchmark "Float64 Array" <|
            \_ ->
                JsTypedArray.extract 0 5000 float64Array
        ]
