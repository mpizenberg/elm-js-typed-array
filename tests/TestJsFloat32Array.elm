module TestJsFloat32Array
    exposing
        ( encodeDecodeRoundTrip
        , fromArray
        , fromBuffer
        , fromList
        , fromTypedArray
        , initialize
        , repeat
        , unsafeIndexedFromList
        , zeros
        )

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsFloat32Array
import JsTypedArray
import Json.Decode as Decode
import Random
import Test exposing (..)
import TestFuzz


elementSize : Int
elementSize =
    4


negativeInt : Fuzzer Int
negativeInt =
    Fuzz.intRange Random.minInt -1


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
                    JsFloat32Array.fromBuffer byteOffset length buffer
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


zeros : Test
zeros =
    describe "Zeros"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsFloat32Array.zeros length
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array of zeros" <|
            \length ->
                let
                    typedArray =
                        JsFloat32Array.zeros length

                    fromList =
                        JsFloat32Array.fromList (List.repeat length 0)
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Zeros array coherent with generated from list"
        ]


repeat : Test
repeat =
    describe "Repeat"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsFloat32Array.repeat length 42
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array" <|
            \length ->
                let
                    typedArray =
                        JsFloat32Array.repeat length 42

                    fromList =
                        JsFloat32Array.fromList (List.repeat length 42)
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Repeat array coherent with generated from list"
        ]


initialize : Test
initialize =
    describe "Initialize"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsFloat32Array.initialize length toFloat
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array" <|
            \length ->
                let
                    typedArray =
                        JsFloat32Array.initialize length toFloat

                    fromList =
                        JsFloat32Array.fromList (List.map toFloat <| List.range 0 (length - 1))
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Initialize array coherent with generated from list"
        ]


fromList : Test
fromList =
    fuzz TestFuzz.jsFloat32Array "From List to List round trip" <|
        \typedArray ->
            typedArray
                |> JsTypedArray.toList
                |> JsFloat32Array.fromList
                |> JsTypedArray.equal typedArray
                |> Expect.true "Should be equal"


unsafeIndexedFromList : Test
unsafeIndexedFromList =
    describe "unsafeIndexedFromList"
        [ fuzz (Fuzz.list Fuzz.float) "is coherent with fromList" <|
            \list ->
                let
                    length =
                        List.length list

                    incrementedFromList =
                        List.indexedMap (\id float -> toFloat id + float) list
                            |> JsFloat32Array.fromList
                in
                JsFloat32Array.unsafeIndexedFromList length (\id float -> toFloat id + float) list
                    |> JsTypedArray.equal incrementedFromList
                    |> Expect.true "should be equal"
        ]


fromArray : Test
fromArray =
    fuzz TestFuzz.jsFloat32Array "From Array to Array round trip" <|
        \typedArray ->
            typedArray
                |> JsTypedArray.toArray
                |> JsFloat32Array.fromArray
                |> JsTypedArray.equal typedArray
                |> Expect.true "Should be equal"


fromTypedArray : Test
fromTypedArray =
    describe "From Typed Array"
        [ fuzz TestFuzz.jsUint8Array "Correct array" <|
            \uint8Array ->
                let
                    fromTypedArray =
                        JsFloat32Array.fromTypedArray uint8Array

                    fromList =
                        JsTypedArray.toList uint8Array
                            |> List.map toFloat
                            |> JsFloat32Array.fromList
                in
                JsTypedArray.equal fromTypedArray fromList
                    |> Expect.true "fromTypedArray coherent with fromList"
        ]


encodeDecodeRoundTrip : Test
encodeDecodeRoundTrip =
    fuzz TestFuzz.jsFloat32Array "Encode-Decode round trip" <|
        \typedArray ->
            typedArray
                |> JsTypedArray.encode
                |> Decode.decodeValue JsFloat32Array.decode
                |> Result.withDefault (JsFloat32Array.zeros 0)
                |> JsTypedArray.equal typedArray
                |> Expect.true "Encode-Decode round trip"
