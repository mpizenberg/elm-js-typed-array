module JsUint8Array
    exposing
        ( fromArray
        , fromBuffer
        , fromList
        , initialize
        )

{-| Provides functions to initialize JS `Uint8Array`.

@docs initialize, fromBuffer, fromArray, fromList

-}

import Array exposing (Array)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsTypedArray exposing (JsTypedArray, Uint8)
import Native.JsUint8Array


elementSize : Int
elementSize =
    1


{-| Initialize an array of 0 of a given length.

Internally uses `new Uint8Array( length )`.

Complexity: O(length).

-}
initialize : Int -> JsTypedArray Uint8 Int
initialize length =
    Native.JsUint8Array.initialize (max 0 length)


{-| Initialize an array from a buffer.

Internally uses `new Uint8Array( buffer, byteOffset, length )`.

Complexity: O(1).

-}
fromBuffer : Int -> Int -> JsArrayBuffer -> Result String (JsTypedArray Uint8 Int)
fromBuffer byteOffset length buffer =
    if byteOffset < 0 then
        Err ("Negative offset: " ++ toString byteOffset)
    else if length < 0 then
        Err ("Negative length: " ++ toString length)
    else if byteOffset % elementSize /= 0 then
        Err ("Offset (" ++ toString byteOffset ++ ") not a multiple of element size in bytes:" ++ toString elementSize)
    else if byteOffset + elementSize * length > JsArrayBuffer.length buffer then
        Err "Overflows buffer size"
    else
        Ok (Native.JsUint8Array.fromBuffer byteOffset length buffer)


{-| Initialize from an array of integers.
-}
fromArray : Array Int -> JsTypedArray Uint8 Int
fromArray array =
    Debug.crash "TODO"


{-| Initialize from a list of integers.
-}
fromList : List Int -> JsTypedArray Uint8 Int
fromList list =
    Native.JsUint8Array.fromList (List.length list) list
