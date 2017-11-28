module JsUint8ClampedArray exposing (..)

{-| The `JsUint8ClampedArray` typed array represents an array
of 8-bit unsigned integers clamped to 0-255;
if you specify a value that is out of the range of [0,255],
0 or 255 will be set instead.

@docs JsUint8ClampedArray


# Creating `JsUint8ClampedArray`

@docs initialize, fromBuffer, fromArray, fromList


# Basic Requests

@docs length, getAt, buffer, bufferOffset


# Predicates

Predicates here are functions taking an index, a value, and returning a boolean.
(`Int -> Int -> Bool`).
The following functions use predicates to analyze arrays.

@docs all, any, find, findLast, filter


# Array Extraction

@docs extract


# Array Transformations

Transform a `JsUint8ClampedArray` into another `JsUint8ClampedArray`.
All such transformations imply a full copy of the array
to avoid side effects.
Complexity is thus greater than O(length).

@docs replaceWithConstant, copyWithin, map, reverse, sort, reverseSort


# Array Reductions

Reduce an array to a single value.

@docs join, foldl, foldr

-}

import Array exposing (Array)
import JsArrayBuffer exposing (JsArrayBuffer)


{-| Wrapper type for JS Uint8ClampedArray.
-}
type JsUint8ClampedArray
    = JsUint8ClampedArray



-- CREATION ##########################################################


{-| Initialize an array of 0 of a given length.

Internally uses `new Uint8ClampedArray( length )`.

Complexity: O(length).

-}
initialize : Int -> JsUint8ClampedArray
initialize length =
    Debug.crash "TODO"


{-| Initialize an array from a buffer.

Internally uses `new Uint8ClampedArray( buffer, byteOffset, length )`.

Complexity: O(1).

-}
fromBuffer : Int -> Int -> JsArrayBuffer -> JsUint8ClampedArray
fromBuffer byteOffset length buffer =
    Debug.crash "TODO"


{-| Initialize a `JsUint8ClampedArray` from `Array Int`.
-}
fromArray : Array Int -> JsUint8ClampedArray
fromArray array =
    Debug.crash "TODO"


{-| Initialize a `JsUint8ClampedArray` from `List Int`.
-}
fromList : List Int -> JsUint8ClampedArray
fromList list =
    Debug.crash "TODO"



-- BASIC REQUESTS ####################################################


{-| Get the number of elements in the array.

Internally uses `Uint8ClampedArray.prototype.length`.
Beware that this length is different from its buffer length.

Complexity: O(1).

-}
length : JsUint8ClampedArray -> Int
length array =
    Debug.crash "TODO"


{-| Get the value at given index.

Return `Nothing` if index is outside of bounds.

Complexity: O(1).

-}
getAt : Int -> JsUint8ClampedArray -> Maybe Int
getAt index array =
    Debug.crash "TODO"


{-| Get the underlying data buffer of the array.

Internally uses `Uint8ClampedArray.prototype.buffer`.

Complexity: O(1).

-}
buffer : JsUint8ClampedArray -> JsArrayBuffer
buffer array =
    Debug.crash "TODO"


{-| Get the offset (in bytes) from the start of its corresponding buffer.

Internally uses `Uint8ClampedArray.prototype.byteOffset`.

Complexity: O(1).

-}
bufferOffset : JsUint8ClampedArray -> Int
bufferOffset array =
    Debug.crash "TODO"



-- PREDICATES ########################################################


{-| Return `True` if all elements satisfy the predicate.

Internally uses `Uint8ClampedArray.prototype.every`.

Complexity: O(length).

-}
all : (Int -> Int -> Bool) -> JsUint8ClampedArray -> Bool
all predicate array =
    Debug.crash "TODO"


{-| Return `True` if at least one element satisfies the predicate.

Internally uses `Uint8ClampedArray.prototype.some`.

Complexity: O(length).

-}
any : (Int -> Int -> Bool) -> JsUint8ClampedArray -> Bool
any predicate array =
    Debug.crash "TODO"


{-| Returns the index of the first element satisfying the predicate.

If no element satisfies it, returns `Nothing`.
The predicate is a function taking 2 arguments, an index and a value,
and evaluates to True or False.
Internally uses `Uint8ClampedArray.prototype.findIndex`.

Complexity: O(length).

-}
find : (Int -> Int -> Bool) -> JsUint8ClampedArray -> Int
find predicate array =
    Debug.crash "TODO"


{-| Returns the index of the last element satisfying the predicate.

See `find` for details.
Internally uses `Uint8ClampedArray.prototype.lastIndexOf`.

Complexity: O(length).

-}
findLast : (Int -> Int -> Bool) -> JsUint8ClampedArray -> Int
findLast predicate array =
    Debug.crash "TODO"


{-| Filter an array, keeping only elements satisfying the predicate.

Internally uses `Uint8ClampedArray.prototype.filter`.

Complexity: O(length).

-}
filter : (Int -> Int -> Bool) -> JsUint8ClampedArray -> JsUint8ClampedArray
filter predicate array =
    Debug.crash "TODO"



-- ARRAY EXTRACTIONS #################################################


{-| Extract a region of the array.

Internally uses `Uint8ClampedArray.prototype.subarray`
which reuses the same buffer, changing offset and length attributes.

Complexity: O(1).

-}
extract : Int -> Int -> JsUint8ClampedArray -> JsUint8ClampedArray
extract start end array =
    Debug.crash "TODO"



-- ARRAY TRANSFORMATIONS #############################################


{-| Replace a segment of the array by a constant value.

Internally uses `Uint8ClampedArray.prototype.fill`.

Complexity: O(length).

-}
replaceWithConstant : Int -> Int -> Int -> JsUint8ClampedArray -> JsUint8ClampedArray
replaceWithConstant start end value array =
    Debug.crash "TODO"


{-| Replace a segment of the array by another segment.

Internally uses `Uint8ClampedArray.prototype.copyWithin`.

Complexity: O(length).

-}
copyWithin : Int -> Int -> Int -> JsUint8ClampedArray -> JsUint8ClampedArray
copyWithin targetStart sourceStart sourceEnd array =
    Debug.crash "TODO"


{-| Apply a function to every element of the array.

Internally uses `Uint8ClampedArray.prototype.map`.

Complexity: O(length).

-}
map : (Int -> Int -> Int) -> JsUint8ClampedArray -> JsUint8ClampedArray
map f array =
    Debug.crash "TODO"


{-| Reverse the array.

Internally uses `Uint8ClampedArray.prototype.reverse`.

Complexity: O(length).

-}
reverse : JsUint8ClampedArray -> JsUint8ClampedArray
reverse array =
    Debug.crash "TODO"


{-| Sort the array.

Internally uses `Uint8ClampedArray.prototype.sort`.

Complexity: depends on browser implementation.

-}
sort : JsUint8ClampedArray -> JsUint8ClampedArray
sort array =
    Debug.crash "TODO"


{-| Sort the array in reverse order.

Internally uses `Uint8ClampedArray.prototype.sort`.

Complexity: depends on browser implementation.

-}
reverseSort : JsUint8ClampedArray -> JsUint8ClampedArray
reverseSort array =
    Debug.crash "TODO"



-- ARRAY REDUCTIONS ##################################################


{-| Join array values in a string using the given separator.

Internally uses `Uint8ClampedArray.prototype.join`.

Complexity: O(length).

-}
join : Char -> JsUint8ClampedArray -> String
join separator array =
    Debug.crash "TODO"


{-| Reduce the array from the left.

Internally uses `Uint8ClampedArray.prototype.reduce`.

Complexity: O(length).

-}
foldl : (Int -> Int -> a -> a) -> a -> JsUint8ClampedArray -> a
foldl f acc array =
    Debug.crash "TODO"


{-| Reduce the array from the right.

Internally uses `Uint8ClampedArray.prototype.reduceRight`.

Complexity: O(length).

-}
foldr : (Int -> Int -> a -> a) -> a -> JsUint8ClampedArray -> a
foldr f acc array =
    Debug.crash "TODO"
