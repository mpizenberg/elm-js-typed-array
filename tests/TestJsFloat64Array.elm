module TestJsFloat64Array
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
import JsFloat64Array
import JsTypedArray
import Json.Decode as Decode
import Random
import Test exposing (..)
import TestFuzz


elementSize : Int
elementSize =
    8


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
                    JsFloat64Array.fromBuffer byteOffset length buffer
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
                JsFloat64Array.zeros length
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array of zeros" <|
            \length ->
                let
                    typedArray =
                        JsFloat64Array.zeros length

                    fromList =
                        JsFloat64Array.fromList (List.repeat length 0)
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Zeros array coherent with generated from list"
        ]


repeat : Test
repeat =
    describe "Repeat"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsFloat64Array.repeat length 42
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array" <|
            \length ->
                let
                    typedArray =
                        JsFloat64Array.repeat length 42

                    fromList =
                        JsFloat64Array.fromList (List.repeat length 42)
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Repeat array coherent with generated from list"
        ]


initialize : Test
initialize =
    describe "Initialize"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsFloat64Array.initialize length toFloat
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array" <|
            \length ->
                let
                    typedArray =
                        JsFloat64Array.initialize length toFloat

                    fromList =
                        JsFloat64Array.fromList (List.map toFloat <| List.range 0 (length - 1))
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Initialize array coherent with generated from list"
        ]


fromList : Test
fromList =
    fuzz (Fuzz.list Fuzz.float) "From List to List round trip" <|
        \list ->
            JsFloat64Array.fromList list
                |> JsTypedArray.toList
                |> Expect.equal list


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
                            |> JsFloat64Array.fromList
                in
                JsFloat64Array.unsafeIndexedFromList length (\id float -> toFloat id + float) list
                    |> JsTypedArray.equal incrementedFromList
                    |> Expect.true "should be equal"
        ]


fromArray : Test
fromArray =
    fuzz (Fuzz.array Fuzz.float) "From Array to Array round trip" <|
        \array ->
            JsFloat64Array.fromArray array
                |> JsTypedArray.toArray
                |> Expect.equal array


fromTypedArray : Test
fromTypedArray =
    describe "From Typed Array"
        [ fuzz TestFuzz.jsUint8Array "Correct array" <|
            \uint8Array ->
                let
                    fromTypedArray =
                        JsFloat64Array.fromTypedArray uint8Array

                    fromList =
                        JsTypedArray.toList uint8Array
                            |> List.map toFloat
                            |> JsFloat64Array.fromList
                in
                JsTypedArray.equal fromTypedArray fromList
                    |> Expect.true "fromTypedArray coherent with fromList"
        ]


encodeDecodeRoundTrip : Test
encodeDecodeRoundTrip =
    fuzz TestFuzz.jsFloat64Array "Encode-Decode round trip" <|
        \typedArray ->
            typedArray
                |> JsTypedArray.encode
                |> Decode.decodeValue JsFloat64Array.decode
                |> Result.withDefault (JsFloat64Array.zeros 0)
                |> JsTypedArray.equal typedArray
                |> Expect.true "Encode-Decode round trip"
