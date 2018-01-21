module TestJsDataView
    exposing
        ( byteLength
        , byteOffset
        , fromBuffer
        , getterSetterRoundTrip
        )

import Expect
import Fuzz exposing (Fuzzer)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsDataView exposing (JsDataView)
import MutableJsDataView
import Random
import Test exposing (..)
import TestFuzz


negativeInt : Fuzzer Int
negativeInt =
    Fuzz.intRange Random.minInt -1


byteLength : Test
byteLength =
    fuzz TestFuzz.jsDataView "byteLength" <|
        \dataView ->
            JsDataView.byteLength dataView
                |> Expect.atLeast 0


byteOffset : Test
byteOffset =
    fuzz TestFuzz.jsDataView "byteOffset" <|
        \dataView ->
            JsDataView.byteOffset dataView
                |> Expect.atLeast 0


fromBuffer : Test
fromBuffer =
    describe "fromBuffer"
        [ fuzz3 negativeInt TestFuzz.length TestFuzz.jsArrayBuffer "with negative offset" <|
            \offset length buffer ->
                JsDataView.fromBuffer offset length buffer
                    |> Expect.err
        , fuzz3 TestFuzz.length negativeInt TestFuzz.jsArrayBuffer "with negative length" <|
            \offset length buffer ->
                JsDataView.fromBuffer offset length buffer
                    |> Expect.err
        , fuzz3 TestFuzz.length TestFuzz.length TestFuzz.jsArrayBuffer "with positive offset and length" <|
            \offset length buffer ->
                if offset + length > JsArrayBuffer.length buffer then
                    JsDataView.fromBuffer offset length buffer
                        |> Expect.err
                else
                    let
                        isValid dataView =
                            ( JsDataView.byteOffset dataView == offset
                            , JsDataView.byteLength dataView == length
                            , JsDataView.buffer dataView
                                |> JsArrayBuffer.equal buffer
                            )
                                |> Expect.equal ( True, True, True )
                    in
                    JsDataView.fromBuffer offset length buffer
                        |> Result.map isValid
                        |> Result.withDefault (Expect.fail "fromBuffer should not have failed")
        ]


type alias Getter a =
    Int -> JsDataView -> Result JsArrayBuffer.RangeError a


type alias Setter a =
    Int -> a -> JsDataView -> JsDataView


roundTrip : Getter number -> Setter number -> Int -> JsDataView -> Bool
roundTrip getter setter index dataView =
    getter index dataView
        |> Result.map (\val -> ( val, setter index val dataView ))
        |> Result.map (\( val, view ) -> val == (Result.withDefault 0 <| getter index view))
        |> Result.withDefault False


validGetterSetterRoundTrip : Int -> Getter number -> Setter number -> JsDataView -> Bool
validGetterSetterRoundTrip elementSize getter setter dataView =
    let
        roundTripAt index =
            roundTrip getter setter index dataView

        length =
            JsDataView.byteLength dataView

        fittingNbElem =
            length // elementSize
    in
    List.range 0 (fittingNbElem - 1)
        |> List.map ((*) elementSize)
        |> List.foldl (\id acc -> acc && roundTripAt id) True


getterSetterRoundTrip : Test
getterSetterRoundTrip =
    describe "getter setter round trip" <|
        [ fuzz TestFuzz.jsDataView "int8" <|
            \dataView ->
                validGetterSetterRoundTrip 1 JsDataView.getInt8 MutableJsDataView.setInt8 dataView
                    |> Expect.true "Round trip should have worked on all values"
        , fuzz TestFuzz.jsDataView "uint8" <|
            \dataView ->
                validGetterSetterRoundTrip 1 JsDataView.getUint8 MutableJsDataView.setUint8 dataView
                    |> Expect.true "Round trip should have worked on all values"
        , fuzz TestFuzz.jsDataView "int16" <|
            \dataView ->
                validGetterSetterRoundTrip 2 JsDataView.getInt16 MutableJsDataView.setInt16 dataView
                    |> Expect.true "Round trip should have worked on all values"
        , fuzz TestFuzz.jsDataView "uint16" <|
            \dataView ->
                validGetterSetterRoundTrip 2 JsDataView.getUint16 MutableJsDataView.setUint16 dataView
                    |> Expect.true "Round trip should have worked on all values"
        , fuzz TestFuzz.jsDataView "int32" <|
            \dataView ->
                validGetterSetterRoundTrip 4 JsDataView.getInt32 MutableJsDataView.setInt32 dataView
                    |> Expect.true "Round trip should have worked on all values"
        , fuzz TestFuzz.jsDataView "uint32" <|
            \dataView ->
                validGetterSetterRoundTrip 4 JsDataView.getUint32 MutableJsDataView.setUint32 dataView
                    |> Expect.true "Round trip should have worked on all values"
        , fuzz TestFuzz.jsDataView "float32" <|
            \dataView ->
                validGetterSetterRoundTrip 4 JsDataView.getFloat32 MutableJsDataView.setFloat32 dataView
                    |> Expect.true "Round trip should have worked on all values"
        , fuzz TestFuzz.jsDataView "float64" <|
            \dataView ->
                validGetterSetterRoundTrip 8 JsDataView.getFloat64 MutableJsDataView.setFloat64 dataView
                    |> Expect.true "Round trip should have worked on all values"
        ]
