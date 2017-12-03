module TestJsUint8Array
    exposing
        ( fromBuffer
        , initialize
        )

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsTypedArray
import JsUint8Array
import Random
import Test exposing (..)
import TestFuzz


elementSize : Int
elementSize =
    1


negativeInt : Fuzzer Int
negativeInt =
    Fuzz.intRange Random.minInt -1


maxLength : Int
maxLength =
    1000 // elementSize


lengthFuzzer : Fuzzer Int
lengthFuzzer =
    Fuzz.intRange 0 maxLength


initialize : Test
initialize =
    describe "Initialization and length"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz lengthFuzzer "Initialize with correct length" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.length
                    |> Expect.equal length
        ]


fromBuffer : Test
fromBuffer =
    fuzz3 Fuzz.int Fuzz.int TestFuzz.jsArrayBuffer "Initialize from buffer" <|
        \byteOffset length buffer ->
            let
                errorCase =
                    (byteOffset < 0)
                        || (length < 0)
                        || (byteOffset % elementSize /= 0)
                        || (byteOffset + elementSize * length > JsArrayBuffer.length buffer)

                arrayFromBuffer =
                    JsUint8Array.fromBuffer byteOffset length buffer
            in
            case ( errorCase, arrayFromBuffer ) of
                ( True, Err _ ) ->
                    Expect.pass

                ( True, Ok _ ) ->
                    Expect.fail "An error should have been returned"

                ( False, Err _ ) ->
                    Expect.fail "No error should have been returned"

                ( False, Ok array ) ->
                    array
                        |> Expect.all
                            [ JsTypedArray.length >> Expect.equal length
                            , JsTypedArray.bufferOffset >> Expect.equal byteOffset
                            , JsTypedArray.buffer >> Expect.equal buffer
                            ]
