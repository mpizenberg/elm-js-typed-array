module AnyWorstCase exposing (..)

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
        describe "Any (worst case: all false)" <|
            [ lists
            , hamtArrays
            , uint8Arrays
            , float64Arrays
            ]


arrayAny : (a -> Bool) -> Array a -> Bool
arrayAny f array =
    let
        helper i =
            case Array.get i array of
                Nothing ->
                    False

                Just value ->
                    case f value of
                        True ->
                            True

                        False ->
                            helper (i + 1)
    in
    helper 0


lists : Benchmark
lists =
    Constants.sizeScales
        |> List.map (\size -> ( size, List.repeat size 0 ))
        |> List.map (\( size, list ) -> ( toString size, \_ -> List.any (\x -> x == 1) list ))
        |> scale "List"


hamtArrays : Benchmark
hamtArrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> arrayAny (\x -> x == 1) array ))
        |> scale "Hamt Array"


uint8Arrays : Benchmark
uint8Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsUint8Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> JsTypedArray.any (\x -> x == 1) array ))
        |> scale "Uint8 Array"


float64Arrays : Benchmark
float64Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsFloat64Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> JsTypedArray.any (\x -> x == 1) array ))
        |> scale "Float64 Array"
