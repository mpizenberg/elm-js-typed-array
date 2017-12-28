module JsTypedArray
    exposing
        ( Float64
        , JsTypedArray
        , Uint8
        , buffer
        , bufferOffset
        , extract
        , findIndex
        , foldlr
        , getAt
        , indexedAll
        , indexedAny
        , indexedFilter
        , indexedFoldl
        , indexedFoldl2
        , indexedFoldr
        , indexedFoldr2
        , indexedMap
        , indexedMap2
        , join
        , length
        , replaceWithConstant
        , reverse
        , reverseSort
        , sort
        , unsafeGetAt
        )

{-| This module wraps JavaScript typed arrays in elm.

@docs JsTypedArray

The list of all JavaScript typed arrays representable is as below:

@docs Uint8, Float64


# Typed Array Creation

Functions to initialize typed arrays are in their dedicated modules.
See for example the function `JsUint8Array.zeros : Int -> JsTypedArray Uint8 Int`
in the `JsUint8Array` module.


# Basic Requests

@docs length, getAt, unsafeGetAt, buffer, bufferOffset


# Predicates

Predicates here are functions taking an index, a value, and returning a boolean.
(`Int -> b -> Bool`).
The following functions use predicates to analyze typed arrays.

@docs indexedAll, indexedAny, findIndex, indexedFilter


# Array Extraction

@docs extract


# Array Transformations

Transform a typed array into another of the same type.
All such transformations imply a full copy of the array
to avoid side effects.
Complexity is thus greater than O(length).

@docs replaceWithConstant, indexedMap, indexedMap2, reverse, sort, reverseSort


# Array Reductions

Reduce an array to a single value.

@docs join, indexedFoldl, indexedFoldr, indexedFoldl2, indexedFoldr2, foldlr

-}

import JsArrayBuffer exposing (JsArrayBuffer)
import Native.JsTypedArray


{-| `JsTypedArray a b` represents a [JavaScript typed array][typed-array].

[typed-array]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays

The first type parameter `a` is used to indicate the type of data stored inside
the array. Depending on how you initialize the array,
it may be `Uint8`, `Int32`, `Float64` etc.
The second type parameter `b` is used to indicate which elm type is compatible
with the data type in the array. Most probably, it will be `Int` or `Float`.

Those type parameters (`a` and `b`) are fixed at the creation of the array.
For example, a function generating a JavaScript `Uint8Array` will have the return type:
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
Beware that this length (in number of elements)
is different from its buffer length (in bytes).

Complexity: O(1).

    JsUint8Array.zeros 5
        |> JsTypedArray.length
    --> 5

-}
length : JsTypedArray a b -> Int
length =
    Native.JsTypedArray.length


{-| Get the value at given index.
Return `Nothing` if index is outside of bounds.

Complexity: O(1).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.getAt 2
    --> Just 42

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.getAt 3
    --> Nothing

-}
getAt : Int -> JsTypedArray a b -> Maybe b
getAt index array =
    if 0 <= index && index < length array then
        Just (Native.JsTypedArray.getAt index array)
    else
        Nothing


{-| Same as `getAt` but unsafe.
Return JS undefined if index is outside of bounds.
Only useful if performance is required.
-}
unsafeGetAt : Int -> JsTypedArray a b -> b
unsafeGetAt index array =
    Native.JsTypedArray.getAt index array


{-| Get the underlying data buffer of the array.
Internally uses `TypedArray.prototype.buffer`.

Complexity: O(1).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.buffer
        |> JsArrayBuffer.length
    --> 3

    JsFloat64Array.fromList [0, 14, 42]
        |> JsTypedArray.buffer
        |> JsArrayBuffer.length
    --> 24

-}
buffer : JsTypedArray a b -> JsArrayBuffer
buffer =
    Native.JsTypedArray.buffer


{-| Get the offset (in bytes) from the start of its corresponding buffer.
Internally uses `TypedArray.prototype.byteOffset`.

Complexity: O(1).

    JsArrayBuffer.zeros 5
        |> JsUint8Array.fromBuffer 3 2
        |> Result.map JsTypedArray.bufferOffset
    --> Ok 3

-}
bufferOffset : JsTypedArray a b -> Int
bufferOffset =
    Native.JsTypedArray.bufferOffset



-- PREDICATES ########################################################


{-| Return `True` if all elements satisfy the predicate.
Internally uses `TypedArray.prototype.every`.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.indexedAll (\_ v -> v < 50)
    --> True

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.indexedAll (\_ v -> v < 20)
    --> False

-}
indexedAll : (Int -> b -> Bool) -> JsTypedArray a b -> Bool
indexedAll =
    Native.JsTypedArray.indexedAll


{-| Return `True` if at least one element satisfies the predicate.
Internally uses `TypedArray.prototype.some`.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.indexedAny (\_ v -> v > 50)
    --> False

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.indexedAny (\_ v -> v > 20)
    --> True

-}
indexedAny : (Int -> b -> Bool) -> JsTypedArray a b -> Bool
indexedAny =
    Native.JsTypedArray.indexedAny


{-| Return the index of the first element satisfying the predicate.
If no element satisfies it, returns `Nothing`.
Internally uses `TypedArray.prototype.findIndex`.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.findIndex (\_ v -> v > 20)
    --> Just 2

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.findIndex (\_ v -> v > 50)
    --> Nothing

-}
findIndex : (Int -> b -> Bool) -> JsTypedArray a b -> Maybe Int
findIndex =
    Native.JsTypedArray.findIndex


{-| Filter an array, keeping only elements satisfying the predicate.
Internally uses `TypedArray.prototype.filter`.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.indexedFilter (\_ v -> v > 20)
    --> { 0 = 42 }

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.indexedFilter (\_ v -> v < 20)
    --> { 0 = 0, 1 = 14 }

-}
indexedFilter : (Int -> b -> Bool) -> JsTypedArray a b -> JsTypedArray a b
indexedFilter =
    Native.JsTypedArray.indexedFilter



-- ARRAY EXTRACTIONS #################################################


{-| Extract a segment of the array between given start (included)
and end (excluded) indices.
Internally uses `TypedArray.prototype.subarray`
which reuses the same buffer, changing offset and length attributes.
Thus this is extremely fast since it doesn't copy the data buffer.

In case of negative indices, count backward from end of array.

Complexity: O(1).

    f64Array =
        JsFloat64Array.fromList [0, 14, 42]
            |> JsTypedArray.extract 1 3
    --> { 0 = 14, 1 = 42 }

    JsTypedArray.bufferOffset f64Array
    --> 8

    JsFloat64Array.fromList [0, 14, 42]
        |> JsTypedArray.extract -2 -1
    --> { 0 = 14 }

    JsFloat64Array.fromList [0, 14, 42]
        |> JsTypedArray.extract -2 100000
    --> { 0 = 14, 1 = 42 }

-}
extract : Int -> Int -> JsTypedArray a b -> JsTypedArray a b
extract =
    Native.JsTypedArray.extract



-- ARRAY TRANSFORMATIONS #############################################


{-| Replace a segment [start, end[ of the array by a constant value.
Internally uses `TypedArray.prototype.fill`.

Negative indices are counted backward from end of array.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.replaceWithConstant 1 3 17
    --> { 0 = 0, 1 = 17, 2 = 17 }

-}
replaceWithConstant : Int -> Int -> b -> JsTypedArray a b -> JsTypedArray a b
replaceWithConstant =
    Native.JsTypedArray.replaceWithConstant


{-| Apply a function to every element of the array.
Internally uses `TypedArray.prototype.map`.

Complexity: O(length).

    JsUint8Array.zeros 3
        |> JsTypedArray.indexedMap (\id _ -> id)
    --> { 0 = 0, 1 = 1, 2 = 2 }

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.indexedMap (\_ v -> v + 1)
    --> { 0 = 1, 1 = 15, 2 = 43 }

-}
indexedMap : (Int -> b -> b) -> JsTypedArray a b -> JsTypedArray a b
indexedMap =
    Native.JsTypedArray.indexedMap


{-| Apply a function to every element of two arrays to form a new one.
The bigger array is troncated at the size of the smaller one.

Complexity: O(length).

    array1 =
        JsUint8Array.fromList [ 0, 1, 2 ]

    array2 =
        JsUint8Array.fromList [ 0, 14, 42 ]

    array3 =
        JsUint8Array.fromList [ 0, 1, 2, 3, 4, 5, 6, 7 ]

    JsTypedArray.indexedMap2 (\_ x y -> x + y) array1 array2
    --> { 0 = 0, 1 = 15, 2 = 44 }

    JsTypedArray.indexedMap2 (\_ x y -> x + y) array1 array3
    --> { 0 = 0, 1 = 2, 2 = 4 }

-}
indexedMap2 : (Int -> b -> b -> b) -> JsTypedArray a b -> JsTypedArray a b -> JsTypedArray a b
indexedMap2 f typedArray1 typedArray2 =
    let
        newLength =
            min (length typedArray1) (length typedArray2)

        newArray1 =
            extract 0 newLength typedArray1

        newArray2 =
            extract 0 newLength typedArray2
    in
    Native.JsTypedArray.indexedMap2 f newArray1 newArray2


{-| Reverse the array.
Internally uses `TypedArray.prototype.reverse`.

Complexity: O(length).

-}
reverse : JsTypedArray a b -> JsTypedArray a b
reverse =
    Native.JsTypedArray.reverse


{-| Sort the array.
Internally uses `TypedArray.prototype.sort`.

Complexity: depends on browser implementation.

-}
sort : JsTypedArray a b -> JsTypedArray a b
sort =
    Native.JsTypedArray.sort


{-| Sort the array in reverse order.
Internally uses `TypedArray.prototype.sort`.

Complexity: depends on browser implementation.

-}
reverseSort : JsTypedArray a b -> JsTypedArray a b
reverseSort =
    Native.JsTypedArray.reverseSort



-- ARRAY REDUCTIONS ##################################################


{-| Join array values in a string using the given separator.
Internally uses `TypedArray.prototype.join`.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.join ','
    --> "0,14,42"

-}
join : Char -> JsTypedArray a b -> String
join =
    Native.JsTypedArray.join


{-| Reduce the array from the left.
Internally uses `TypedArray.prototype.reduce`.

Complexity: O(length).

    sumArray : JsTypedArray a number -> number
    sumArray =
        JsTypedArray.indexedFoldl (always (+)) 0

    JsUint8Array.fromList [0, 14, 42]
        |> sumArray
    --> 56

-}
indexedFoldl : (Int -> b -> c -> c) -> c -> JsTypedArray a b -> c
indexedFoldl =
    Native.JsTypedArray.indexedFoldl


{-| Reduce the array from the right.
Internally uses `TypedArray.prototype.reduceRight`.

Complexity: O(length).

    arrayToList : JsTypedArray a b -> List b
    arrayToList =
        JsTypedArray.indexedFoldr (always (::)) []

    JsUint8Array.fromList [0, 14, 42]
        |> arrayToList
    --> [0, 14, 42]

-}
indexedFoldr : (Int -> b -> c -> c) -> c -> JsTypedArray a b -> c
indexedFoldr =
    Native.JsTypedArray.indexedFoldr


{-| Reduce two arrays from the left.
The longer array is troncated at the size of the smaller one.

Complexity: O(length).

    innerProduct : JsTypedArray a number -> JsTypedArray a number -> number
    innerProduct =
        JsTypedArray.indexedFoldl2 (\_ x y product -> x * y + product) 0

    array1 =
        JsUint8Array.fromList [0, 1, 2]

    array2 =
        JsUint8Array.fromList [0, 14, 42, 10000]

    innerProduct array1 array2
    --> 98

-}
indexedFoldl2 : (Int -> b -> b -> c -> c) -> c -> JsTypedArray a b -> JsTypedArray a b -> c
indexedFoldl2 f initialValue typedArray1 typedArray2 =
    let
        newLength =
            min (length typedArray1) (length typedArray2)

        newArray1 =
            extract 0 newLength typedArray1

        newArray2 =
            extract 0 newLength typedArray2
    in
    Native.JsTypedArray.indexedFoldl2 f initialValue newArray1 newArray2


{-| Reduce two arrays from the right.
The longer array is troncated at the size of the smaller one.

Complexity: O(length).

    toZipList : JsTypedArray a b -> JsTypedArray a b -> List (b,b)
    toZipList =
        JsTypedArray.indexedFoldr2 (\_ x y list -> (x,y) :: list) []

    array1 =
        JsUint8Array.fromList [0, 1, 2]

    array2 =
        JsUint8Array.fromList [0, 14, 42, 10000]

    toZipList array1 array2
    --> [(0,14),(1,42),(2,1000)]

-}
indexedFoldr2 : (Int -> b -> b -> c -> c) -> c -> JsTypedArray a b -> JsTypedArray a b -> c
indexedFoldr2 f initialValue typedArray1 typedArray2 =
    let
        length1 =
            length typedArray1

        length2 =
            length typedArray2

        newLength =
            min length1 length2

        newArray1 =
            extract (length1 - newLength) length1 typedArray1

        newArray2 =
            extract (length2 - newLength) length2 typedArray2
    in
    Native.JsTypedArray.indexedFoldr2 f initialValue newArray1 newArray2


{-| Reduce two arrays, first from left, second from right
The longer array is troncated at the size of the smaller one.

Complexity: O(length).

TODO: example + tests

-}
foldlr : (b -> b -> c -> c) -> c -> JsTypedArray a b -> JsTypedArray a b -> c
foldlr f initialValue typedArray1 typedArray2 =
    let
        length2 =
            length typedArray2

        newLength =
            min (length typedArray1) (length typedArray2)

        newArray1 =
            extract 0 newLength typedArray1

        newArray2 =
            extract (length2 - newLength) length2 typedArray2
    in
    Native.JsTypedArray.foldlr f initialValue newArray1 newArray2
