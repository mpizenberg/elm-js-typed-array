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


{-| Initialize an array of 0 of a given length.

Internally uses `new Uint8Array( length )`.

Complexity: O(length).

-}
initialize : Int -> JsTypedArray Uint8 Int
initialize length =
    Debug.crash "TODO"


{-| Initialize an array from a buffer.

Internally uses `new Uint8Array( buffer, byteOffset, length )`.

Complexity: O(1).

-}
fromBuffer : Int -> Int -> JsArrayBuffer -> JsTypedArray Uint8 Int
fromBuffer byteOffset length buffer =
    Debug.crash "TODO"


{-| Initialize from an array of integers.
-}
fromArray : Array Int -> JsTypedArray Uint8 Int
fromArray array =
    Debug.crash "TODO"


{-| Initialize from a list of integers.
-}
fromList : List Int -> JsTypedArray Uint8 Int
fromList list =
    Debug.crash "TODO"
