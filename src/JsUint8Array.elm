module JsUint8Array
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

{-| Provides functions to initialize JavaScript [`Uint8Array`][Uint8Array].

Those functions return arrays of type `JsTypedArray Uint8 Int`
that can then be manipulated with the `JsTypedArray` module.

[Uint8Array]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array

@docs zeros, repeat, initialize, fromBuffer, fromArray, fromList, fromTypedArray, fromValue, decode

@docs unsafeIndexedFromList

-}

import Array exposing (Array)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsTypedArray exposing (JsTypedArray, Uint8)
import Json.Decode as Decode exposing (Decoder)
import Native.JsUint8Array


elementSize : Int
elementSize =
    1


{-| Initialize an array of zeros of a given length.
Internally uses `new Uint8Array( length )`.
This is the fastest way of initializing an array of zeros.

Complexity: O(length).

    JsUint8Array.zeros 3
    --> { 0 = 0, 1 = 0, 2 = 0 } : JsTypedArray Uint8 Int

-}
zeros : Int -> JsTypedArray Uint8 Int
zeros length =
    Native.JsUint8Array.zeros (max 0 length)


{-| Initialize an array of a given length with the same constant.

Complexity: O(length).

    JsUint8Array.repeat 3 42
    --> { 0 = 42, 1 = 42, 2 = 42 } : JsTypedArray Uint8 Int

-}
repeat : Int -> Int -> JsTypedArray Uint8 Int
repeat length =
    Native.JsUint8Array.repeat (max 0 length)


{-| Initialize an array applying a function to each index.

Complexity: O(length).

    JsUint8Array.initialize 3 (\n -> n * n)
    --> { 0 = 0, 1 = 1, 2 = 4 } : JsTypedArray Uint8 Int

-}
initialize : Int -> (Int -> Int) -> JsTypedArray Uint8 Int
initialize length =
    Native.JsUint8Array.initialize (max 0 length)


{-| Initialize an array from a buffer at a given offset (in bytes), of a given length.
Internally uses `new Uint8Array( buffer, byteOffset, length )`.

Complexity: O(1).

    JsArrayBuffer.zeros 5
        |> JsUint8Array.fromBuffer 0 3
    --> Ok { 0 = 0, 1 = 0, 2 = 0 }

    JsArrayBuffer.zeros 5
        |> JsUint8Array.fromBuffer -1 3
    --> Err "Negative offset: -1"

    JsArrayBuffer.zeros 5
        |> JsUint8Array.fromBuffer 0 -2
    --> Err "Negative length: -2"

    JsArrayBuffer.zeros 5
        |> JsUint8Array.fromBuffer 3 4
    --> Err "Overflows buffer size (5 bytes)"

    JsArrayBuffer.zeros 5
        |> JsUint8Array.fromBuffer 3 2
    --> Ok { 0 = 0, 1 = 0 }

-}
fromBuffer : Int -> Int -> JsArrayBuffer -> Result String (JsTypedArray Uint8 Int)
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
        Ok (Native.JsUint8Array.fromBuffer byteOffset length buffer)


{-| Create a typed array from an elm Array.

Complexity: O(length)

    JsUint8Array.fromArray (Array.repeat 3 42)
    --> { 0 = 42, 1 = 42, 2 = 42 }

-}
fromArray : Array Int -> JsTypedArray Uint8 Int
fromArray array =
    let
        arrayValue n =
            Array.get n array
                |> Maybe.withDefault 0
    in
    initialize (Array.length array) arrayValue


{-| Initialize from a list of integers.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
    --> { 0 = 0, 1 = 14, 2 = 42 }

-}
fromList : List Int -> JsTypedArray Uint8 Int
fromList list =
    Native.JsUint8Array.fromList (List.length list) list


{-| Initialize from a list of elements (unsafe).
The array length is provided as a parameter to
avoid one walk through the list.
Index of current element in the list can also be used.

Complexity: O(length).

    JsUint8Array.unsafeIndexedFromList 3 (+) [ 0, 14, 42 ]
    --> { 0 = 0, 1 = 15, 2 = 44 }

-}
unsafeIndexedFromList : Int -> (Int -> a -> Int) -> List a -> JsTypedArray Uint8 Int
unsafeIndexedFromList =
    Native.JsUint8Array.unsafeIndexedFromList


{-| Convert from another typed array.
Numbers are truncated, not rounded.

Complexity: O(length).

    JsFloat64Array.fromList [0, -1.6, 14.66, 257]
        |> JsUint8Array.fromTypedArray
    --> { 0 = 0, 1 = 255, 2 = 14, 3 = 1 } : JsTypedArray Uint8 Int

-}
fromTypedArray : JsTypedArray a b -> JsTypedArray Uint8 Int
fromTypedArray =
    Native.JsUint8Array.fromTypedArray


{-| `JsTypedArray Uint8 Int` decoder.
-}
decode : Decoder (JsTypedArray Uint8 Int)
decode =
    let
        maybeToDecoder =
            Maybe.map Decode.succeed
                >> Maybe.withDefault (Decode.fail "Value is not a Uint8Array")
    in
    Decode.value
        |> Decode.map fromValue
        |> Decode.andThen maybeToDecoder


{-| Transform a compatible JavaScript value into a typed array.
Returns Nothing in value is not a Uint8Array.
-}
fromValue : Decode.Value -> Maybe (JsTypedArray Uint8 Int)
fromValue =
    Native.JsUint8Array.fromValue
