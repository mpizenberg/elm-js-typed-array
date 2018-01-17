module TestJsArrayBuffer
    exposing
        ( encodeDecodeRoundTrip
        , slice
        , zeros
        )

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)
import Json.Decode as Decode
import List
import Random
import Test exposing (..)
import TestFuzz


negativeInt : Fuzzer Int
negativeInt =
    Fuzz.intRange Random.minInt -1


zeros : Test
zeros =
    describe "Initialization and length"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsArrayBuffer.zeros length
                    |> JsArrayBuffer.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Initialize an array buffer with correct length" <|
            \length ->
                JsArrayBuffer.zeros length
                    |> JsArrayBuffer.length
                    |> Expect.equal length
        ]


arrayIndex : Int -> Int -> Int
arrayIndex length idx =
    if idx < 0 then
        max 0 (length + idx)
    else
        idx


ordered : List Int -> Bool
ordered list =
    list == List.sort list


slice : Test
slice =
    describe "Slicing"
        [ fuzz3 TestFuzz.length TestFuzz.length TestFuzz.length "Slice with positive indices" <|
            \length start end ->
                let
                    arrayBuffer =
                        JsArrayBuffer.zeros length

                    slicedArrayBuffer =
                        JsArrayBuffer.slice start end arrayBuffer
                in
                if ordered [ start, 0, length, end ] then
                    slicedArrayBuffer
                        |> Expect.equal arrayBuffer
                else if ordered [ start, length, end ] then
                    slicedArrayBuffer
                        |> JsArrayBuffer.length
                        |> Expect.equal (length - start)
                else if ordered [ start, end, length ] then
                    slicedArrayBuffer
                        |> JsArrayBuffer.length
                        |> Expect.equal (end - start)
                else
                    slicedArrayBuffer
                        |> JsArrayBuffer.length
                        |> Expect.equal 0
        , fuzz3 TestFuzz.length Fuzz.int Fuzz.int "Slice with any indices" <|
            \length start end ->
                let
                    arrayBuffer =
                        JsArrayBuffer.zeros length

                    slicedArrayBuffer =
                        JsArrayBuffer.slice start end arrayBuffer

                    slicedPositiveIndices =
                        JsArrayBuffer.slice (arrayIndex length start) (arrayIndex length end) arrayBuffer
                in
                slicedArrayBuffer
                    |> JsArrayBuffer.equal slicedPositiveIndices
                    |> Expect.true "Should be equal"
        ]


encodeDecodeRoundTrip : Test
encodeDecodeRoundTrip =
    fuzz TestFuzz.jsArrayBuffer "Encode-Decode round trip" <|
        \arrayBuffer ->
            arrayBuffer
                |> JsArrayBuffer.encode
                |> Decode.decodeValue JsArrayBuffer.decode
                |> Result.withDefault (JsArrayBuffer.zeros 0)
                |> JsArrayBuffer.equal arrayBuffer
                |> Expect.true "Encode-Decode round trip"
