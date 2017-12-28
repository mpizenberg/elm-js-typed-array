module JsFloat64Array
    exposing
        ( fromArray
        , fromBuffer
        , fromList
        , initialize
        , repeat
        , zeros
        )

{-| Provides functions to initialize JavaScript [`Float64Array`][Float64Array].

Those functions return arrays of type `JsTypedArray Float64 Float`
that can then be manipulated with the `JsTypedArray` module.

[Float64Array]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Float64Array

@docs zeros, repeat, initialize, fromBuffer, fromArray, fromList

-}

import Array exposing (Array)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsTypedArray exposing (Float64, JsTypedArray)
import Native.JsFloat64Array


elementSize : Int
elementSize =
    8


{-| Initialize an array of zeros of a given length.
Internally uses `new Float64Array( length )`.

Complexity: O(length).

    JsFloat64Array.zeros 3
    --> { 0 = 0, 1 = 0, 2 = 0 } : JsTypedArray Float64 Float

-}
zeros : Int -> JsTypedArray Float64 Float
zeros length =
    Native.JsFloat64Array.zeros (max 0 length)


{-| Initialize an array of a given length with the same constant.

Complexity: O(length).

    JsFloat64Array.repeat 3 42
    --> { 0 = 42, 1 = 42, 2 = 42 } : JsTypedArray Float64 Float

-}
repeat : Int -> Float -> JsTypedArray Float64 Float
repeat length =
    Native.JsFloat64Array.repeat (max 0 length)


{-| Initialize an array applying a function to each index.

Complexity: O(length).

    JsFloat64Array.initialize 3 (\n -> n * n)
    --> { 0 = 0, 1 = 1, 2 = 4 } : JsTypedArray Float64 Float

-}
initialize : Int -> (Int -> Float) -> JsTypedArray Float64 Float
initialize length =
    Native.JsFloat64Array.initialize (max 0 length)


{-| Initialize an array from a buffer at a given offset (in bytes), of a given length.
Internally uses `new Float64Array( buffer, byteOffset, length )`.

Complexity: O(1).

    JsArrayBuffer.zeros (3 * 8)
        |> JsFloat64Array.fromBuffer 0 3
    --> Ok { 0 = 0, 1 = 0, 2 = 0 }

    JsArrayBuffer.zeros (3 * 8)
        |> JsFloat64Array.fromBuffer -1 3
    --> Err "Negative offset: -1"

    JsArrayBuffer.zeros (3 * 8)
        |> JsFloat64Array.fromBuffer 0 -2
    --> Err "Negative length: -2"

    JsArrayBuffer.zeros (3 * 8)
        |> JsFloat64Array.fromBuffer 1 2
    --> Err "Provided offset (1) not a multiple of element size in bytes (8)"

    JsArrayBuffer.zeros (3 * 8)
        |> JsFloat64Array.fromBuffer (1*8) 3
    --> Err "Overflows buffer size (24 bytes)"

    JsArrayBuffer.zeros (3 * 8)
        |> JsFloat64Array.fromBuffer (1*8) 2
    --> Ok { 0 = 0, 1 = 0 }

-}
fromBuffer : Int -> Int -> JsArrayBuffer -> Result String (JsTypedArray Float64 Float)
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
        Ok (Native.JsFloat64Array.fromBuffer byteOffset length buffer)


{-| Initialize from an array of integers.
-}
fromArray : Array Float -> JsTypedArray Float64 Float
fromArray array =
    Debug.crash "TODO"


{-| Initialize from a list of floats.

Complexity: O(length).

    JsFloat64Array.fromList [0.5, 14.5, 42.5]
    --> { 0 = 0.5, 1 = 14.5, 2 = 42.5 }

-}
fromList : List Float -> JsTypedArray Float64 Float
fromList list =
    Native.JsFloat64Array.fromList (List.length list) list
