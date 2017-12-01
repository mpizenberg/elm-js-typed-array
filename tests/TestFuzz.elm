module TestFuzz
    exposing
        ( jsArrayBuffer
        )

import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)


maxLength : Int
maxLength =
    16000000


lengthFuzzer : Fuzzer Int
lengthFuzzer =
    Fuzz.intRange 0 maxLength


jsArrayBuffer : Fuzzer JsArrayBuffer
jsArrayBuffer =
    Fuzz.map JsArrayBuffer.initialize lengthFuzzer
