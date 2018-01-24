module TestJsDataView
    exposing
        ( byteLength
        , byteOffset
        , fromBuffer
        , getterSetterRoundTrip
        )

import Expect exposing (Expectation)
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


roundTrip : Getter number -> Setter number -> Int -> JsDataView -> ( number, number )
roundTrip getter setter index dataView =
    getter index dataView
        |> Result.map (\val -> ( val, setter index val dataView ))
        |> Result.map (\( val, newDataView ) -> ( val, Result.withDefault 0 <| getter index newDataView ))
        |> Result.withDefault ( 0, 0 )


validGetterSetterRoundTrip : Int -> Getter number -> Setter number -> JsDataView -> ( List number, List number )
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
        |> List.foldl (\id acc -> roundTripAt id :: acc) []
        |> List.unzip


expectFloatListEqual : List Float -> List Float -> Expectation
expectFloatListEqual l1 l2 =
    let
        expectFloatEqual x y =
            if isNaN x && isNaN y then
                Expect.pass
            else
                Expect.equal x y
    in
    case ( l1, l2 ) of
        ( [], [] ) ->
            Expect.pass

        _ ->
            Expect.all (List.map2 (\x y -> always (expectFloatEqual x y)) l1 l2) ()


getterSetterRoundTrip : Test
getterSetterRoundTrip =
    describe "getter setter round trip" <|
        [ fuzz TestFuzz.jsDataView "int8" <|
            \dataView ->
                validGetterSetterRoundTrip 1 JsDataView.getInt8 MutableJsDataView.setInt8 dataView
                    |> (\( l1, l2 ) -> Expect.equal l1 l2)
        , fuzz TestFuzz.jsDataView "uint8" <|
            \dataView ->
                validGetterSetterRoundTrip 1 JsDataView.getUint8 MutableJsDataView.setUint8 dataView
                    |> (\( l1, l2 ) -> Expect.equal l1 l2)
        , fuzz TestFuzz.jsDataView "int16" <|
            \dataView ->
                validGetterSetterRoundTrip 2 JsDataView.getInt16 MutableJsDataView.setInt16 dataView
                    |> (\( l1, l2 ) -> Expect.equal l1 l2)
        , fuzz TestFuzz.jsDataView "uint16" <|
            \dataView ->
                validGetterSetterRoundTrip 2 JsDataView.getUint16 MutableJsDataView.setUint16 dataView
                    |> (\( l1, l2 ) -> Expect.equal l1 l2)
        , fuzz TestFuzz.jsDataView "int32" <|
            \dataView ->
                validGetterSetterRoundTrip 4 JsDataView.getInt32 MutableJsDataView.setInt32 dataView
                    |> (\( l1, l2 ) -> Expect.equal l1 l2)
        , fuzz TestFuzz.jsDataView "uint32" <|
            \dataView ->
                validGetterSetterRoundTrip 4 JsDataView.getUint32 MutableJsDataView.setUint32 dataView
                    |> (\( l1, l2 ) -> Expect.equal l1 l2)
        , fuzz TestFuzz.jsDataView "float32" <|
            \dataView ->
                validGetterSetterRoundTrip 4 JsDataView.getFloat32 MutableJsDataView.setFloat32 dataView
                    |> (\( l1, l2 ) -> expectFloatListEqual l1 l2)
        , fuzz TestFuzz.jsDataView "float64" <|
            \dataView ->
                validGetterSetterRoundTrip 8 JsDataView.getFloat64 MutableJsDataView.setFloat64 dataView
                    |> (\( l1, l2 ) -> expectFloatListEqual l1 l2)
        ]
