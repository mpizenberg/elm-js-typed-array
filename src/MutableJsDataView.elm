module MutableJsDataView
    exposing
        ( MutableJsDataView
        , setFloat32
        , setFloat64
        , setInt16
        , setInt32
        , setInt8
        , setUint16
        , setUint32
        , setUint8
        )

{-| Provides functions on [DataView] modifying the underlying buffer.

[DataView]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView

@docs MutableJsDataView

@docs setInt8, setUint8, setInt16, setUint16, setInt32, setUint32

@docs setFloat32, setFloat64

-}

import JsDataView exposing (JsDataView)
import Native.MutableJsDataView


{-| Alias for a `JsDataView`. Reminder of the mutability aspect of functions.
-}
type alias MutableJsDataView =
    JsDataView


{-| Write an Int8 at the given offset (added to JsDataView own offset).
-}
setInt8 : Int -> Int -> MutableJsDataView -> MutableJsDataView
setInt8 offset value dataView =
    if offset < 0 then
        dataView
    else if offset >= JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setInt8 offset value dataView


{-| Write an Uint8 at the given offset (added to JsDataView own offset).
-}
setUint8 : Int -> Int -> MutableJsDataView -> MutableJsDataView
setUint8 offset value dataView =
    if offset < 0 then
        dataView
    else if offset >= JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setUint8 offset value dataView


{-| Write an Int16 at the given offset (added to DataView own offset).
-}
setInt16 : Int -> Int -> MutableJsDataView -> MutableJsDataView
setInt16 offset value dataView =
    if offset < 0 then
        dataView
    else if offset + 2 > JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setInt16 offset value dataView


{-| Write an Uint16 at the given offset (added to DataView own offset).
-}
setUint16 : Int -> Int -> MutableJsDataView -> MutableJsDataView
setUint16 offset value dataView =
    if offset < 0 then
        dataView
    else if offset + 2 > JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setUint16 offset value dataView


{-| Write an Int32 at the given offset (added to DataView own offset).
-}
setInt32 : Int -> Int -> MutableJsDataView -> MutableJsDataView
setInt32 offset value dataView =
    if offset < 0 then
        dataView
    else if offset + 4 > JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setInt32 offset value dataView


{-| Write an Uint32 at the given offset (added to DataView own offset).
-}
setUint32 : Int -> Int -> MutableJsDataView -> MutableJsDataView
setUint32 offset value dataView =
    if offset < 0 then
        dataView
    else if offset + 4 > JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setUint32 offset value dataView


{-| Write a Float32 at the given offset (added to DataView own offset).
-}
setFloat32 : Int -> Float -> MutableJsDataView -> MutableJsDataView
setFloat32 offset value dataView =
    if offset < 0 then
        dataView
    else if offset + 4 > JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setFloat32 offset value dataView


{-| Write a Float64 at the given offset (added to DataView own offset).
-}
setFloat64 : Int -> Float -> MutableJsDataView -> MutableJsDataView
setFloat64 offset value dataView =
    if offset < 0 then
        dataView
    else if offset + 8 > JsDataView.byteLength dataView then
        dataView
    else
        Native.MutableJsDataView.setFloat64 offset value dataView
