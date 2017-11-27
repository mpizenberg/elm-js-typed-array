module JsArrayBuffer
    exposing
        ( JsArrayBuffer
        , initialize
        , length
        , slice
        )

{-| This module is wrapping native javascript ArrayBuffer.

[ArrayBuffer] documentation is available on MDN web docs.

[ArrayBuffer]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer

@docs JsArrayBuffer, initialize, length, slice

-}

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
initialize : Int -> JsArrayBuffer
initialize int =
    Native.JsArrayBuffer.initialize (max 0 int)


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
