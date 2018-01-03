module JsTypedArray
    exposing
        ( Float64
        , JsTypedArray
        , Uint8
        , all
        , any
        , append
        , buffer
        , bufferOffset
        , encode
        , equal
        , extract
        , filter
        , findIndex
        , foldl
        , foldl2
        , foldlr
        , foldr
        , foldr2
        , getAt
        , indexedAll
        , indexedAny
        , indexedFilter
        , indexedFindIndex
        , indexedFoldl
        , indexedFoldl2
        , indexedFoldr
        , indexedFoldr2
        , indexedMap
        , indexedMap2
        , join
        , length
        , map
        , map2
        , replaceWithConstant
        , reverse
        , reverseSort
        , sort
        , toArray
        , toList
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


# Interoperability

There are `fromList` and `fromArray` functions available in dedicated modules.
For example, in module `JsUint8Array`:

    JsUint8Array.fromList : List Int -> JsTypedArray Uint8 Int

    JsUint8Array.fromArray : Array Int -> JsTypedArray Uint8 Int

In this module are provided the `toList` and `toArray` polymorphic functions.

@docs toList, toArray

Encoders and decoders are providing instant data exchange through ports.
The typed arrays are not "converted" since they already are JavaScript values.
A `decode` function is available in each dedicated modules,
and the polymorphic `encode` function is in this module.

@docs encode


# Basic Requests

@docs length, getAt, unsafeGetAt, buffer, bufferOffset


# Predicates

Predicates here are functions returning a boolean.
They come in two flavors. The `indexed...` version is additionally using
the index as the first argument of the function to evaluate.
The following functions use predicates to analyze typed arrays.

@docs all, any, findIndex, filter

@docs indexedAll, indexedAny, indexedFindIndex, indexedFilter


# Comparison

@docs equal


# Array Extraction and Appending

@docs extract, append


# Array Transformations

Transform a typed array into another of the same type.
All such transformations imply a full copy of the array
to avoid side effects.
Complexity is thus greater than O(length).

@docs replaceWithConstant, map, map2, reverse, sort, reverseSort

@docs indexedMap, indexedMap2


# Array Reductions

Reduce an array to a single value.

@docs join, foldl, foldr, foldl2, foldr2, foldlr

Indexed versions of reducers.

@docs indexedFoldl, indexedFoldr, indexedFoldl2, indexedFoldr2

-}

import Array exposing (Array)
import JsArrayBuffer exposing (JsArrayBuffer)
import Json.Encode as Encode
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



-- INTEROPERABILITY ##################################################


{-| Convert a typed array to a list.

    JsUint8Array.fromList [ 0, 14, 42 ]
        |> JsTypedArray.toList
    --> [ 0, 14, 42 ]

-}
toList : JsTypedArray a b -> List b
toList =
    foldr (\x acc -> x :: acc) []


{-| Convert a typed array to an array.

    JsUint8Array.fromList [ 0, 14, 42 ]
        |> JsTypedArray.toArray
    --> Array.fromList [0,14,42]

-}
toArray : JsTypedArray a b -> Array b
toArray typedArray =
    let
        init n =
            unsafeGetAt n typedArray
    in
    Array.initialize (length typedArray) init


{-| Encode a `JsTypedArray` into a JavaScript `Value`
that can be sent through ports.
-}
encode : JsTypedArray a b -> Encode.Value
encode =
    Native.JsTypedArray.encode



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

Complexity: O(1).

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

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.all (\x -> x < 50)
    --> True

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.all (\x -> x < 20)
    --> False

-}
all : (b -> Bool) -> JsTypedArray a b -> Bool
all =
    Native.JsTypedArray.all


{-| Indexed version of `all`.

Complexity: O(length).

-}
indexedAll : (Int -> b -> Bool) -> JsTypedArray a b -> Bool
indexedAll =
    Native.JsTypedArray.indexedAll


{-| Return `True` if at least one element satisfies the predicate.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.any (\x -> x > 50)
    --> False

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.any (\x -> x > 20)
    --> True

-}
any : (b -> Bool) -> JsTypedArray a b -> Bool
any =
    Native.JsTypedArray.any


{-| Indexed version of `any`.

Complexity: O(length).

-}
indexedAny : (Int -> b -> Bool) -> JsTypedArray a b -> Bool
indexedAny =
    Native.JsTypedArray.indexedAny


{-| Return the index of the first element satisfying the predicate.
If no element satisfies it, returns `Nothing`.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.findIndex (\x -> x > 20)
    --> Just 2

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.findIndex (\x -> x > 50)
    --> Nothing

-}
findIndex : (b -> Bool) -> JsTypedArray a b -> Maybe Int
findIndex =
    Native.JsTypedArray.findIndex


{-| Indexed version of `findIndex`.

Complexity: O(length).

-}
indexedFindIndex : (Int -> b -> Bool) -> JsTypedArray a b -> Maybe Int
indexedFindIndex =
    Native.JsTypedArray.indexedFindIndex


{-| Filter an array, keeping only elements satisfying the predicate.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.filter (\x -> x > 20)
    --> { 0 = 42 }

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.filter (\x -> x < 20)
    --> { 0 = 0, 1 = 14 }

-}
filter : (b -> Bool) -> JsTypedArray a b -> JsTypedArray a b
filter =
    Native.JsTypedArray.filter


{-| Indexed version of `filter`.

Complexity: O(length).

-}
indexedFilter : (Int -> b -> Bool) -> JsTypedArray a b -> JsTypedArray a b
indexedFilter =
    Native.JsTypedArray.indexedFilter



-- COMPARISON ########################################################


{-| Check if two typed arrays are equal.
_WARNING: using the `(==)` operator yields wrong results._
For example:

    JsUint8Array.fromList [] == JsUint8Array.fromList [42]
    --> True

For this reason, we need to introduce a specific function
to check that two typed arrays are equal.

    typedArray1 =
        JsUint8Array.fromList [0, 14, 42]

    typedArray2 =
        JsUint8Array.fromList [0, 14, 42, 1000]

    typedArray3 =
        JsTypedArray.extract 0 3 typedArray2

    JsTypedArray.equal typedArray1 typedArray2
    --> False

    JsTypedArray.equal typedArray1 typedArray3
    --> True

-}
equal : JsTypedArray a b -> JsTypedArray a b -> Bool
equal =
    -- Native implementation is roughly 10 times faster.
    -- I believe the (==) operator is very heavy.
    Native.JsTypedArray.equal



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


{-| Append two arrays of the same type into a new one.

Complexity: O(n).

    typedArray1 =
        JsUint8Array.fromList [ 0, 1 ]

    typedArray2 =
        JsUint8Array.fromList [ 0, 14, 42 ]

    JsTypedArray.append typedArray1 typedArray2
    --> { 0 = 0, 1 = 1, 2 = 0, 3 = 14, 4 = 42 }

-}
append : JsTypedArray a b -> JsTypedArray a b -> JsTypedArray a b
append =
    Native.JsTypedArray.append



-- ARRAY TRANSFORMATIONS #############################################


{-| Replace a segment [start, end[ of the array by a constant value.

Negative indices are counted backward from end of array.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.replaceWithConstant 1 3 17
    --> { 0 = 0, 1 = 17, 2 = 17 }

-}
replaceWithConstant : Int -> Int -> b -> JsTypedArray a b -> JsTypedArray a b
replaceWithConstant start end constant typedArray =
    let
        typedArrayLength =
            length typedArray

        newStart =
            min typedArrayLength <| positiveIndex typedArrayLength start

        newEnd =
            max newStart <| min typedArrayLength <| positiveIndex typedArrayLength end
    in
    Native.JsTypedArray.replaceWithConstant newStart newEnd constant typedArray


{-| Apply a function to every element of the array.

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.map (\x -> x + 1)
    --> { 0 = 1, 1 = 15, 2 = 43 }

-}
map : (b -> b) -> JsTypedArray a b -> JsTypedArray a b
map =
    Native.JsTypedArray.map


{-| Indexed version of `map`.
-}
indexedMap : (Int -> b -> b) -> JsTypedArray a b -> JsTypedArray a b
indexedMap =
    Native.JsTypedArray.indexedMap


{-| Apply a function to every element of two arrays to form a new one.
The bigger array is troncated at the size of the smaller one.

Complexity: O(length).

    typedArray1 =
        JsUint8Array.fromList [ 0, 1, 2 ]

    typedArray2 =
        JsUint8Array.fromList [ 0, 14, 42 ]

    typedArray3 =
        JsUint8Array.fromList [ 0, 1, 2, 3, 4, 5, 6, 7 ]

    JsTypedArray.map2 (+) typedArray1 typedArray2
    --> { 0 = 0, 1 = 15, 2 = 44 }

    JsTypedArray.map2 (+) typedArray1 typedArray3
    --> { 0 = 0, 1 = 2, 2 = 4 }

-}
map2 : (b -> b -> b) -> JsTypedArray a b -> JsTypedArray a b -> JsTypedArray a b
map2 f typedArray1 typedArray2 =
    let
        newLength =
            min (length typedArray1) (length typedArray2)

        newArray1 =
            extract 0 newLength typedArray1

        newArray2 =
            extract 0 newLength typedArray2
    in
    Native.JsTypedArray.map2 f newArray1 newArray2


{-| Indexed version of `map2`.
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

Complexity: O(length).

    JsUint8Array.fromList [0, 14, 42]
        |> JsTypedArray.join ","
    --> "0,14,42"

-}
join : String -> JsTypedArray a b -> String
join str typedArray =
    foldr (\x acc -> toString x :: acc) [] typedArray
        |> String.join str


{-| Reduce the array from the left.

Complexity: O(length).

    sumArray : JsTypedArray a number -> number
    sumArray =
        JsTypedArray.foldl (+) 0

    JsUint8Array.fromList [0, 14, 42]
        |> sumArray
    --> 56

-}
foldl : (b -> c -> c) -> c -> JsTypedArray a b -> c
foldl =
    Native.JsTypedArray.foldl


{-| Indexed version of foldl.
-}
indexedFoldl : (Int -> b -> c -> c) -> c -> JsTypedArray a b -> c
indexedFoldl =
    Native.JsTypedArray.indexedFoldl


{-| Reduce the array from the right.

Complexity: O(length).

    arrayToList : JsTypedArray a b -> List b
    arrayToList =
        JsTypedArray.foldr (::) []

    JsUint8Array.fromList [0, 14, 42]
        |> arrayToList
    --> [0, 14, 42]

-}
foldr : (b -> c -> c) -> c -> JsTypedArray a b -> c
foldr =
    Native.JsTypedArray.foldr


{-| Indexed version of foldr.
-}
indexedFoldr : (Int -> b -> c -> c) -> c -> JsTypedArray a b -> c
indexedFoldr =
    Native.JsTypedArray.indexedFoldr


{-| Reduce two arrays from the left.
The longer array is troncated at the size of the smaller one.

Complexity: O(length).

    innerProduct : JsTypedArray a number -> JsTypedArray a number -> number
    innerProduct =
        JsTypedArray.foldl2 (\x y product -> x * y + product) 0

    typedArray1 =
        JsUint8Array.fromList [0, 1, 2]

    typedArray2 =
        JsUint8Array.fromList [0, 14, 42, 10000]

    innerProduct typedArray1 typedArray2
    --> 98

-}
foldl2 : (b -> b -> c -> c) -> c -> JsTypedArray a b -> JsTypedArray a b -> c
foldl2 f initialValue typedArray1 typedArray2 =
    let
        newLength =
            min (length typedArray1) (length typedArray2)

        newArray1 =
            extract 0 newLength typedArray1

        newArray2 =
            extract 0 newLength typedArray2
    in
    Native.JsTypedArray.foldl2 f initialValue newArray1 newArray2


{-| Indexed version of foldl2.
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
        JsTypedArray.foldr2 (\x y list -> (x,y) :: list) []

    typedArray1 =
        JsUint8Array.fromList [0, 1, 2]

    typedArray2 =
        JsUint8Array.fromList [0, 14, 42, 10000]

    toZipList typedArray1 typedArray2
    --> [ (0,14), (1,42), (2,1000) ]

-}
foldr2 : (b -> b -> c -> c) -> c -> JsTypedArray a b -> JsTypedArray a b -> c
foldr2 f initialValue typedArray1 typedArray2 =
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
    Native.JsTypedArray.foldr2 f initialValue newArray1 newArray2


{-| Indexed version of foldr2.
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

TODO: example

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



-- HELPER ############################################################


{-| Returns a positive index.
-}
positiveIndex : Int -> Int -> Int
positiveIndex length idx =
    if idx < 0 then
        max 0 (length + idx)
    else
        idx
