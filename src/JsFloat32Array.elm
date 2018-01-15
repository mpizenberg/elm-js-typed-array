module JsFloat32Array
    exposing
        ( decode
        , fromArray
        , fromBuffer
        , fromList
        , fromTypedArray
        , fromValue
        , initialize
        , repeat
        , unsafeIndexedFromList
        , zeros
        )

{-| Provides functions to initialize JavaScript [`Float32Array`][Float32Array].

Those functions return arrays of type `JsTypedArray Float32 Float`
that can then be manipulated with the `JsTypedArray` module.

[Float32Array]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Float32Array

@docs zeros, repeat, initialize, fromBuffer, fromArray, fromList, fromTypedArray, fromValue, decode

@docs unsafeIndexedFromList

-}

import Array exposing (Array)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsTypedArray exposing (Float32, JsTypedArray)
import Json.Decode as Decode exposing (Decoder)
import Native.JsFloat32Array


elementSize : Int
elementSize =
    4


{-| Initialize an array of zeros of a given length.
Internally uses `new Float32Array( length )`.

Complexity: O(length).

    JsFloat32Array.zeros 3
    --> { 0 = 0, 1 = 0, 2 = 0 } : JsTypedArray Float32 Float

-}
zeros : Int -> JsTypedArray Float32 Float
zeros length =
    Native.JsFloat32Array.zeros (max 0 length)


{-| Initialize an array of a given length with the same constant.

Complexity: O(length).

    JsFloat32Array.repeat 3 42
    --> { 0 = 42, 1 = 42, 2 = 42 } : JsTypedArray Float32 Float

-}
repeat : Int -> Float -> JsTypedArray Float32 Float
repeat length =
    Native.JsFloat32Array.repeat (max 0 length)


{-| Initialize an array applying a function to each index.

Complexity: O(length).

    JsFloat32Array.initialize 3 (\n -> n * n)
    --> { 0 = 0, 1 = 1, 2 = 4 } : JsTypedArray Float32 Float

-}
initialize : Int -> (Int -> Float) -> JsTypedArray Float32 Float
initialize length =
    Native.JsFloat32Array.initialize (max 0 length)


{-| Initialize an array from a buffer at a given offset (in bytes), of a given length.
Internally uses `new Float32Array( buffer, byteOffset, length )`.

Complexity: O(1).

    JsArrayBuffer.zeros (3 * 4)
        |> JsFloat32Array.fromBuffer 0 3
    --> Ok { 0 = 0, 1 = 0, 2 = 0 }

    JsArrayBuffer.zeros (3 * 4)
        |> JsFloat32Array.fromBuffer -1 3
    --> Err "Negative offset: -1"

    JsArrayBuffer.zeros (3 * 4)
        |> JsFloat32Array.fromBuffer 0 -2
    --> Err "Negative length: -2"

    JsArrayBuffer.zeros (3 * 4)
        |> JsFloat32Array.fromBuffer 1 2
    --> Err "Provided offset (1) not a multiple of element size in bytes (4)"

    JsArrayBuffer.zeros (3 * 4)
        |> JsFloat32Array.fromBuffer (1*4) 3
    --> Err "Overflows buffer size (24 bytes)"

    JsArrayBuffer.zeros (3 * 4)
        |> JsFloat32Array.fromBuffer (1*4) 2
    --> Ok { 0 = 0, 1 = 0 }

-}
fromBuffer : Int -> Int -> JsArrayBuffer -> Result String (JsTypedArray Float32 Float)
fromBuffer byteOffset length buffer =
    if byteOffset < 0 then
        Err ("Negative offset: " ++ toString byteOffset)
    else if length < 0 then
        Err ("Negative length: " ++ toString length)
    else if byteOffset % elementSize /= 0 then
        Err ("Provided offset (" ++ toString byteOffset ++ ") not a multiple of element size in bytes (" ++ toString elementSize ++ ")")
    else if byteOffset + elementSize * length > JsArrayBuffer.length buffer then
        Err ("Overflows buffer size (" ++ toString (JsArrayBuffer.length buffer) ++ " bytes)")
    else
        Ok (Native.JsFloat32Array.fromBuffer byteOffset length buffer)


{-| Create a typed array from an elm Array.

Complexity: O(length)

    JsFloat32Array.fromArray (Array.repeat 3 0.42)
    --> { 0 = 0.42, 1 = 0.42, 2 = 0.42 }

-}
fromArray : Array Float -> JsTypedArray Float32 Float
fromArray array =
    let
        arrayValue n =
            Array.get n array
                |> Maybe.withDefault 0
    in
    initialize (Array.length array) arrayValue


{-| Initialize from a list of floats.

Complexity: O(length).

    JsFloat32Array.fromList [0.5, 14.5, 42.5]
    --> { 0 = 0.5, 1 = 14.5, 2 = 42.5 }

-}
fromList : List Float -> JsTypedArray Float32 Float
fromList list =
    Native.JsFloat32Array.fromList (List.length list) list


{-| Initialize from a list of elements (unsafe).
The array length is provided as a parameter to
avoid one walk through the list.
Index of current element in the list can also be used.

Complexity: O(length).

    indexPlusInt index int =
        toFloat (index + int)

    intList =
        [ 0, 14, 42 ]

    JsFloat32Array.unsafeIndexedFromList 3 indexPlusInt intList
    --> { 0 = 0, 1 = 15, 2 = 44 }

-}
unsafeIndexedFromList : Int -> (Int -> a -> Float) -> List a -> JsTypedArray Float32 Float
unsafeIndexedFromList =
    Native.JsFloat32Array.unsafeIndexedFromList


{-| Convert from another typed array.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsFloat32Array.fromTypedArray
    --> { 0 = 0, 1 = 14, 2 = 42 } : JsTypedArray Float32 Float

-}
fromTypedArray : JsTypedArray a b -> JsTypedArray Float32 Float
fromTypedArray =
    Native.JsFloat32Array.fromTypedArray


{-| `JsTypedArray Float32 Float` decoder.
-}
decode : Decoder (JsTypedArray Float32 Float)
decode =
    let
        maybeToDecoder =
            Maybe.map Decode.succeed
                >> Maybe.withDefault (Decode.fail "Value is not a Float32Array")
    in
    Decode.value
        |> Decode.map fromValue
        |> Decode.andThen maybeToDecoder


{-| Transform a compatible JavaScript value into a typed array.
Returns Nothing in value is not a Float32Array.
-}
fromValue : Decode.Value -> Maybe (JsTypedArray Float32 Float)
fromValue =
    Native.JsFloat32Array.fromValue
