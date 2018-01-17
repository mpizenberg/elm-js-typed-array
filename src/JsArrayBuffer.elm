module JsArrayBuffer
    exposing
        ( JsArrayBuffer
        , decode
        , encode
        , equal
        , fromValue
        , length
        , slice
        , zeros
        )

{-| This module is wrapping javascript [ArrayBuffer].

Array buffers are basic bytes arrays that have to be manipulated
through views (like Uint8Array, Float64Array, etc.).
[ArrayBuffer] documentation is available on MDN web docs.

[ArrayBuffer]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer

@docs JsArrayBuffer, zeros, length, slice, fromValue, encode, decode, equal

-}

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Native.JsArrayBuffer


{-| Representation of a javascript array buffer.
-}
type JsArrayBuffer
    = JsArrayBuffer


{-| Return the length of the array buffer.
-}
length : JsArrayBuffer -> Int
length =
    Native.JsArrayBuffer.length


{-| Initialize an array buffer of a given length.

If `length` is negative, creates an empty array.

-}
zeros : Int -> JsArrayBuffer
zeros int =
    Native.JsArrayBuffer.zeros (max 0 int)


{-| Get a sub section of an array: `(slice start end array)`.
The `start` is a zero-based index where we will start our slice.
The `end` is a zero-based index that indicates the end of the slice.
The slice extracts up to, but no including, the `end`.

Both `start` and `end` can be negative, indicating an offset from the end
of the array. Popping the last element of the array is therefore:
`slice 0 -1 array`.

In the case of an impossible slice, the empty array is returned.

-}
slice : Int -> Int -> JsArrayBuffer -> JsArrayBuffer
slice =
    Native.JsArrayBuffer.slice


{-| Transform a compatible JavaScript value into an array buffer.
Returns Nothing in value is not an array buffer.
-}
fromValue : Decode.Value -> Maybe JsArrayBuffer
fromValue =
    Native.JsArrayBuffer.fromValue


{-| Encode a `JsArrayBuffer` into a JavaScript `Value`
that can be sent through ports.

Complexity: O(1).

-}
encode : JsArrayBuffer -> Encode.Value
encode =
    Native.JsArrayBuffer.encode


{-| `JsArrayBuffer` decoder.
-}
decode : Decoder JsArrayBuffer
decode =
    let
        maybeToDecoder =
            Maybe.map Decode.succeed
                >> Maybe.withDefault (Decode.fail "Value is not an ArrayBuffer")
    in
    Decode.value
        |> Decode.map fromValue
        |> Decode.andThen maybeToDecoder


{-| Check if two array buffers are equal.

_WARNING: using the `(==)` operator yields wrong results._

For example:

    JsArrayBuffer.zeros 0 == JsArrayBuffer.zeros 1
    --> True

-}
equal : JsArrayBuffer -> JsArrayBuffer -> Bool
equal =
    Native.JsArrayBuffer.equal
