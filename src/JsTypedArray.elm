module JsTypedArray
    exposing
        ( Float64
        , JsTypedArray
        , Uint8
        , all
        , any
        , buffer
        , bufferOffset
        , copyWithin
        , extract
        , filter
        , find
        , findLast
        , foldl
        , foldr
        , getAt
        , join
        , length
        , map
        , replaceWithConstant
        , reverse
        , reverseSort
        , sort
        )

{-| This module wraps Javascript typed arrays in elm.

@docs JsTypedArray

The list of all JS typed arrays representable is as below:

@docs Uint8, Float64


# Typed Array Creation

Functions to initialize typed arrays are in their dedicated modules.
See for example the function `JsUint8Array.init : Int -> JsTypedArray Uint8 Int`
in the `JsUint8Array` module.


# Basic Requests

@docs length, getAt, buffer, bufferOffset


# Predicates

Predicates here are functions taking an index, a value, and returning a boolean.
(`Int -> b -> Bool`).
The following functions use predicates to analyze typed arrays.

@docs all, any, find, findLast, filter


# Array Extraction

@docs extract


# Array Transformations

Transform a typed array into another of the same type.
All such transformations imply a full copy of the array
to avoid side effects.
Complexity is thus greater than O(length).

@docs replaceWithConstant, copyWithin, map, reverse, sort, reverseSort


# Array Reductions

Reduce an array to a single value.

@docs join, foldl, foldr

-}

import JsArrayBuffer exposing (JsArrayBuffer)


{-| `JsTypedArray a b` represents a [Javascript typed array][typed-array].

[typed-array]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays

The first type parameter `a` is used to indicate the type of data stored inside
the array. Depending on how you initialize the array,
it may be `Uint8`, `Int32`, `Float64` etc.
The second type parameter `b` is used to indicate which elm type is compatible
with the data type in the array. Most probably, it will be `Int` or `Float`.

Those type parameters (`a` and `b`) are fixed are the creation of the array.
For example, a function generating a Javascript `Uint8Array` will have the return type:
`JsTypedArray Uint8 Int`.

-}
type JsTypedArray a b
    = JsTypedArray


{-| 8-bits unsigned integer.
-}
type Uint8
    = Uint8


{-| 64-bits floating point number.
-}
type Float64
    = Float64



-- BASIC REQUESTS ####################################################


{-| Get the number of elements in the array.

Internally uses `TypedArray.prototype.length`.
Beware that this length is different from its buffer length.

Complexity: O(1).

-}
length : JsTypedArray a b -> Int
length array =
    Debug.crash "TODO"


{-| Get the value at given index.

Return `Nothing` if index is outside of bounds.

Complexity: O(1).

-}
getAt : Int -> JsTypedArray a b -> Maybe b
getAt index array =
    Debug.crash "TODO"


{-| Get the underlying data buffer of the array.

Internally uses `TypedArray.prototype.buffer`.

Complexity: O(1).

-}
buffer : JsTypedArray a b -> JsArrayBuffer
buffer array =
    Debug.crash "TODO"


{-| Get the offset (in bytes) from the start of its corresponding buffer.

Internally uses `TypedArray.prototype.byteOffset`.

Complexity: O(1).

-}
bufferOffset : JsTypedArray a b -> Int
bufferOffset array =
    Debug.crash "TODO"



-- PREDICATES ########################################################


{-| Return `True` if all elements satisfy the predicate.

Internally uses `TypedArray.prototype.every`.

Complexity: O(length).

-}
all : (Int -> b -> Bool) -> JsTypedArray a b -> Bool
all predicate array =
    Debug.crash "TODO"


{-| Return `True` if at least one element satisfies the predicate.

Internally uses `TypedArray.prototype.some`.

Complexity: O(length).

-}
any : (Int -> b -> Bool) -> JsTypedArray a b -> Bool
any predicate array =
    Debug.crash "TODO"


{-| Returns the index of the first element satisfying the predicate.

If no element satisfies it, returns `Nothing`.
Internally uses `TypedArray.prototype.findIndex`.

Complexity: O(length).

-}
find : (Int -> b -> Bool) -> JsTypedArray a b -> Int
find predicate array =
    Debug.crash "TODO"


{-| Returns the index of the last element satisfying the predicate.

See `find` for details.
Internally uses `TypedArray.prototype.lastIndexOf`.

Complexity: O(length).

-}
findLast : (Int -> b -> Bool) -> JsTypedArray a b -> Int
findLast predicate array =
    Debug.crash "TODO"


{-| Filter an array, keeping only elements satisfying the predicate.

Internally uses `TypedArray.prototype.filter`.

Complexity: O(length).

-}
filter : (Int -> b -> Bool) -> JsTypedArray a b -> JsTypedArray a b
filter predicate array =
    Debug.crash "TODO"



-- ARRAY EXTRACTIONS #################################################


{-| Extract a region of the array.

Internally uses `TypedArray.prototype.subarray`
which reuses the same buffer, changing offset and length attributes.

Complexity: O(1).

-}
extract : Int -> Int -> JsTypedArray a b -> JsTypedArray a b
extract start end array =
    Debug.crash "TODO"



-- ARRAY TRANSFORMATIONS #############################################


{-| Replace a segment of the array by a constant value.

Internally uses `TypedArray.prototype.fill`.

Complexity: O(length).

-}
replaceWithConstant : Int -> Int -> b -> JsTypedArray a b -> JsTypedArray a b
replaceWithConstant start end value array =
    Debug.crash "TODO"


{-| Replace a segment of the array by another segment.

Internally uses `TypedArray.prototype.copyWithin`.

Complexity: O(length).

-}
copyWithin : Int -> Int -> Int -> JsTypedArray a b -> JsTypedArray a b
copyWithin targetStart sourceStart sourceEnd array =
    Debug.crash "TODO"


{-| Apply a function to every element of the array.

Internally uses `TypedArray.prototype.map`.

Complexity: O(length).

-}
map : (Int -> b -> b) -> JsTypedArray a b -> JsTypedArray a b
map f array =
    Debug.crash "TODO"


{-| Reverse the array.

Internally uses `TypedArray.prototype.reverse`.

Complexity: O(length).

-}
reverse : JsTypedArray a b -> JsTypedArray a b
reverse array =
    Debug.crash "TODO"


{-| Sort the array.

Internally uses `TypedArray.prototype.sort`.

Complexity: depends on browser implementation.

-}
sort : JsTypedArray a b -> JsTypedArray a b
sort array =
    Debug.crash "TODO"


{-| Sort the array in reverse order.

Internally uses `TypedArray.prototype.sort`.

Complexity: depends on browser implementation.

-}
reverseSort : JsTypedArray a b -> JsTypedArray a b
reverseSort array =
    Debug.crash "TODO"



-- ARRAY REDUCTIONS ##################################################


{-| Join array values in a string using the given separator.

Internally uses `TypedArray.prototype.join`.

Complexity: O(length).

-}
join : Char -> JsTypedArray a b -> String
join separator array =
    Debug.crash "TODO"


{-| Reduce the array from the left.

Internally uses `TypedArray.prototype.reduce`.

Complexity: O(length).

-}
foldl : (Int -> b -> c -> c) -> c -> JsTypedArray a b -> c
foldl f acc array =
    Debug.crash "TODO"


{-| Reduce the array from the right.

Internally uses `TypedArray.prototype.reduceRight`.

Complexity: O(length).

-}
foldr : (Int -> b -> c -> c) -> c -> JsTypedArray a b -> c
foldr f acc array =
    Debug.crash "TODO"
