module TestFuzz
    exposing
        ( jsArrayBuffer
        , jsDataView
        , jsFloat32Array
        , jsFloat64Array
        , jsUint8Array
        , length
        )

import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsDataView exposing (JsDataView)
import JsFloat32Array
import JsFloat64Array
import JsTypedArray exposing (Float32, Float64, JsTypedArray, Uint8)
import JsUint8Array
import Random


maxLength : Int
maxLength =
    100


length : Fuzzer Int
length =
    Fuzz.intRange 0 maxLength


jsArrayBuffer : Fuzzer JsArrayBuffer
jsArrayBuffer =
    Fuzz.map JsArrayBuffer.zeros length


jsDataView : Fuzzer JsDataView
jsDataView =
    jsUint8Array
        |> Fuzz.map JsTypedArray.buffer
        |> Fuzz.map (\buffer -> JsDataView.fromBuffer 0 (JsArrayBuffer.length buffer) buffer)
        |> Fuzz.map (Result.withDefault JsDataView.empty)


jsUint8Array : Fuzzer (JsTypedArray Uint8 Int)
jsUint8Array =
    randomJsTypedArray JsUint8Array.fromList (Random.int 0 255)


jsFloat64Array : Fuzzer (JsTypedArray Float64 Float)
jsFloat64Array =
    randomJsTypedArray JsFloat64Array.fromList (Random.float -(10 ^ 10) (10 ^ 10))


jsFloat32Array : Fuzzer (JsTypedArray Float32 Float)
jsFloat32Array =
    randomJsTypedArray JsFloat32Array.fromList (Random.float -(10 ^ 10) (10 ^ 10))



-- RANDOM GENERATORS HELPERS #########################################


randomJsTypedArray : (List b -> JsTypedArray a b) -> Random.Generator b -> Fuzzer (JsTypedArray a b)
randomJsTypedArray arrayFromList generator =
    Fuzz.map2 (generateRandomArray arrayFromList generator) length Fuzz.int


generateRandomArray : (List b -> JsTypedArray a b) -> Random.Generator b -> Int -> Int -> JsTypedArray a b
generateRandomArray arrayFromList generator arrayLength intSeed =
    Random.initialSeed intSeed
        |> Random.step (Random.list arrayLength generator)
        |> Tuple.first
        |> arrayFromList
