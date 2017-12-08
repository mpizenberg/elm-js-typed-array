module JsFloat64Array
    exposing
        ( fromArray
        , fromBuffer
        , fromList
        , initialize
        )

{-| Provides functions to initialize JS `Float64Array`.

@docs initialize, fromBuffer, fromArray, fromList

-}

import Array exposing (Array)
import JsArrayBuffer exposing (JsArrayBuffer)
import JsTypedArray exposing (Float64, JsTypedArray)
import Native.JsFloat64Array


elementSize : Int
elementSize =
    8


{-| Initialize an array of 0 of a given length.

Internally uses `new Float64Array( length )`.

Complexity: O(length).

-}
initialize : Int -> JsTypedArray Float64 Float
initialize length =
    Native.JsFloat64Array.initialize (max 0 length)


{-| Initialize an array from a buffer.

Internally uses `new Float64Array( buffer, byteOffset, length )`.

Complexity: O(1).

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


{-| Initialize from a list of integers.
-}
fromList : List Float -> JsTypedArray Float64 Float
fromList list =
    Native.JsFloat64Array.fromList (List.length list) list
