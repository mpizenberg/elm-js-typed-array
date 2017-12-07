module TestFuzz
    exposing
        ( jsArrayBuffer
        , jsUint8Array
        , length
        )

import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsTypedArray exposing (JsTypedArray, Uint8)
import JsUint8Array
import Random


maxLength : Int
maxLength =
    16000


length : Fuzzer Int
length =
    Fuzz.intRange 0 maxLength


jsArrayBuffer : Fuzzer JsArrayBuffer
jsArrayBuffer =
    Fuzz.map JsArrayBuffer.initialize length


jsUint8Array : Fuzzer (JsTypedArray Uint8 Int)
jsUint8Array =
    randomJsTypedArray JsUint8Array.fromList (Random.int 0 255)



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
