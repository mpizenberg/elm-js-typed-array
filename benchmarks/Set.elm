module Set exposing (..)

import Array.Hamt as Array
import Benchmark exposing (..)
import Benchmark.Runner exposing (BenchmarkProgram, program)
import Constants
import JsFloat64Array
import JsTypedArray exposing (JsTypedArray)
import JsUint8Array


main : BenchmarkProgram
main =
    program <|
        describe "Set a value at half size" <|
            [ lists
            , hamtArrays
            , uint8Arrays
            , float64Arrays
            ]


listSet : Int -> a -> List a -> List a
listSet n value list =
    case list of
        [] ->
            []

        _ :: tail ->
            case n of
                0 ->
                    value :: tail

                _ ->
                    listSet (n - 1) value tail


typedArraySet : Int -> b -> JsTypedArray a b -> JsTypedArray a b
typedArraySet n =
    JsTypedArray.replaceWithConstant n (n + 1)


lists : Benchmark
lists =
    Constants.sizeScales
        |> List.map (\size -> ( size, List.repeat size 0 ))
        |> List.map (\( size, list ) -> ( toString size, \_ -> listSet (size // 2) 0 list ))
        |> scale "List"


hamtArrays : Benchmark
hamtArrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> Array.set (size // 2) 0 array ))
        |> scale "Hamt Array"


uint8Arrays : Benchmark
uint8Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsUint8Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> typedArraySet (size // 2) 0 array ))
        |> scale "Uint8 Array"


float64Arrays : Benchmark
float64Arrays =
    Constants.sizeScales
        |> List.map (\size -> ( size, JsFloat64Array.repeat size 0 ))
        |> List.map (\( size, array ) -> ( toString size, \_ -> typedArraySet (size // 2) 0 array ))
        |> scale "Float64 Array"
