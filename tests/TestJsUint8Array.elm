module TestJsUint8Array
    exposing
        ( encodeDecodeRoundTrip
        , fromArray
        , fromBuffer
        , fromList
        , fromTypedArray
        , initialize
        , repeat
        , zeros
        )

import Array
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsFloat64Array
import JsTypedArray
import JsUint8Array
import Json.Decode as Decode
import Random
import Test exposing (..)
import TestFuzz


elementSize : Int
elementSize =
    1


negativeInt : Fuzzer Int
negativeInt =
    Fuzz.intRange Random.minInt -1


zeros : Test
zeros =
    describe "Zeros"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array of zeros" <|
            \length ->
                let
                    typedArray =
                        JsUint8Array.zeros length

                    fromList =
                        JsUint8Array.fromList (List.repeat length 0)
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Zeros array coherent with generated from list"
        ]


repeat : Test
repeat =
    describe "Repeat"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsUint8Array.repeat length 42
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array" <|
            \length ->
                let
                    typedArray =
                        JsUint8Array.repeat length 42

                    fromList =
                        JsUint8Array.fromList (List.repeat length 42)
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Repeat array coherent with generated from list"
        ]


initialize : Test
initialize =
    describe "Initialize"
        [ fuzz negativeInt "Initialize with negative length returns empty array" <|
            \length ->
                JsUint8Array.initialize length identity
                    |> JsTypedArray.length
                    |> Expect.equal 0
        , fuzz TestFuzz.length "Correct array" <|
            \length ->
                let
                    typedArray =
                        JsUint8Array.initialize length identity

                    fromList =
                        JsUint8Array.fromList (List.range 0 (length - 1))
                in
                JsTypedArray.equal typedArray fromList
                    |> Expect.true "Initialize array coherent with generated from list"
        ]


fromList : Test
fromList =
    fuzz (Fuzz.list <| Fuzz.intRange 0 255) "From List to List round trip" <|
        \list ->
            JsUint8Array.fromList list
                |> JsTypedArray.toList
                |> Expect.equal list


fromArray : Test
fromArray =
    describe "From Array"
        [ fuzz (Fuzz.list Fuzz.int) "Correct array" <|
            \list ->
                let
                    fromArray =
                        JsUint8Array.fromArray <| Array.fromList list

                    fromList =
                        JsUint8Array.fromList list
                in
                JsTypedArray.equal fromArray fromList
                    |> Expect.true "fromArray coherent with fromList"
        ]


fromTypedArray : Test
fromTypedArray =
    describe "From Typed Array"
        [ fuzz (Fuzz.list Fuzz.float) "Correct array" <|
            \list ->
                let
                    fromTypedArray =
                        JsFloat64Array.fromList list
                            |> JsUint8Array.fromTypedArray

                    fromList =
                        List.map truncate list
                            |> JsUint8Array.fromList
                in
                JsTypedArray.equal fromTypedArray fromList
                    |> Expect.true "fromTypedArray coherent with truncated fromList"
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


encodeDecodeRoundTrip : Test
encodeDecodeRoundTrip =
    fuzz TestFuzz.jsUint8Array "Encode-Decode round trip" <|
        \typedArray ->
            typedArray
                |> JsTypedArray.encode
                |> Decode.decodeValue JsUint8Array.decode
                |> Result.withDefault (JsUint8Array.zeros 0)
                |> JsTypedArray.equal typedArray
                |> Expect.true "Encode-Decode round trip"
