module JsDataView
    exposing
        ( JsDataView
        , buffer
        , byteLength
        , byteOffset
        , empty
        , fromBuffer
        , getFloat32
        , getFloat64
        , getInt16
        , getInt32
        , getInt8
        , getUint16
        , getUint32
        , getUint8
        )

{-| Provides a low-level interface for reading and writing
multiple number types in an ArrayBuffer, with control over endianness.

[DataView]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView

@docs JsDataView, empty, fromBuffer, buffer, byteLength, byteOffset

@docs getInt8, getUint8, getInt16, getUint16, getInt32, getUint32

@docs getFloat32, getFloat64

-}

import JsArrayBuffer exposing (JsArrayBuffer)
import Native.JsDataView


{-| Corresponds to JavaScript [DataView].
-}
type JsDataView
    = JsDataView


{-| Create an empty JsDataView
-}
empty : JsDataView
empty =
    Native.JsDataView.empty


{-| Initialize a JsDataView on an array buffer, at a given offset, of a given length.
-}
fromBuffer : Int -> Int -> JsArrayBuffer -> Result JsArrayBuffer.RangeError JsDataView
fromBuffer offset length buffer =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if length < 0 then
        Err (JsArrayBuffer.NegativeLength length)
    else if offset + length > JsArrayBuffer.length buffer then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = JsArrayBuffer.length buffer
                , offset = offset
                , byteLength = length
                }
    else
        Ok (Native.JsDataView.fromBuffer offset length buffer)


{-| Return the underlying buffer.
-}
buffer : JsDataView -> JsArrayBuffer
buffer =
    Native.JsDataView.buffer


{-| Length in bytes of the JsDataView.
-}
byteLength : JsDataView -> Int
byteLength =
    Native.JsDataView.byteLength


{-| Offset in bytes of the JsDataView with regard to
the beginning of the underlying array buffer.
-}
byteOffset : JsDataView -> Int
byteOffset =
    Native.JsDataView.byteOffset



-- Read


{-| Read an Int8 at the given offset (added to JsDataView own offset).
-}
getInt8 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Int
getInt8 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset >= byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 1
                }
    else
        Ok (Native.JsDataView.getInt8 offset dataView)


{-| Read an Uint8 at the given offset (added to JsDataView own offset).
-}
getUint8 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Int
getUint8 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset >= byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 1
                }
    else
        Ok (Native.JsDataView.getUint8 offset dataView)


{-| Read an Int16 at the given offset (added to JsDataView own offset).
-}
getInt16 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Int
getInt16 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset + 2 > byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 2
                }
    else
        Ok (Native.JsDataView.getInt16 offset dataView)


{-| Read an Uint16 at the given offset (added to JsDataView own offset).
-}
getUint16 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Int
getUint16 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset + 2 > byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 2
                }
    else
        Ok (Native.JsDataView.getUint16 offset dataView)


{-| Read an Int32 at the given offset (added to JsDataView own offset).
-}
getInt32 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Int
getInt32 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset + 4 > byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 4
                }
    else
        Ok (Native.JsDataView.getInt32 offset dataView)


{-| Read an Uint32 at the given offset (added to JsDataView own offset).
-}
getUint32 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Int
getUint32 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset + 4 > byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 4
                }
    else
        Ok (Native.JsDataView.getUint32 offset dataView)


{-| Read a Float32 at the given offset (added to JsDataView own offset).
-}
getFloat32 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Float
getFloat32 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset + 4 > byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 4
                }
    else
        Ok (Native.JsDataView.getFloat32 offset dataView)


{-| Read a Float64 at the given offset (added to JsDataView own offset).
-}
getFloat64 : Int -> JsDataView -> Result JsArrayBuffer.RangeError Float
getFloat64 offset dataView =
    if offset < 0 then
        Err (JsArrayBuffer.NegativeOffset offset)
    else if offset + 8 > byteLength dataView then
        Err <|
            JsArrayBuffer.BufferOverflow
                { bufferLength = byteLength dataView
                , offset = offset
                , byteLength = 8
                }
    else
        Ok (Native.JsDataView.getFloat64 offset dataView)
