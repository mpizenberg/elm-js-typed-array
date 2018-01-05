module TestJsTypedArray
    exposing
        ( all
        , any
        , append
        , buffer
        , bufferOffset
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
        , unsafeGetAt
        )

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsArrayBuffer
import JsFloat64Array
import JsTypedArray exposing (JsTypedArray, Uint8)
import JsUint8Array
import String
import Test exposing (..)
import TestFuzz


equal : Test
equal =
    describe "equal"
        [ fuzz TestFuzz.jsUint8Array "is reflexive" <|
            \typedArray ->
                JsTypedArray.equal typedArray typedArray
                    |> Expect.true "should be: array == array"
        , fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "is symmetric" <|
            \typedArray1 typedArray2 ->
                JsTypedArray.equal typedArray1 typedArray2
                    |> Expect.equal (JsTypedArray.equal typedArray2 typedArray1)
        , fuzz3 TestFuzz.jsUint8Array TestFuzz.jsUint8Array TestFuzz.jsUint8Array "is transitive" <|
            \typedArray1 typedArray2 typedArray3 ->
                let
                    equal12 =
                        JsTypedArray.equal typedArray1 typedArray2

                    equal23 =
                        JsTypedArray.equal typedArray2 typedArray3

                    equal13 =
                        JsTypedArray.equal typedArray1 typedArray3
                in
                (not equal12 || not equal23 || equal13)
                    |> Expect.true "a & b => c   should be equiv to   -a | -b | c"
        ]


length : Test
length =
    describe "length"
        [ fuzz TestFuzz.length "of array from list" <|
            \length ->
                List.repeat length 0
                    |> JsUint8Array.fromList
                    |> JsTypedArray.length
                    |> Expect.equal length
        ]


buffer : Test
buffer =
    describe "buffer"
        [ fuzz TestFuzz.length "of an Uint8Array has same length" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.buffer
                    |> JsArrayBuffer.length
                    |> Expect.equal length
        , fuzz TestFuzz.length "of a Float64Array has length x 8" <|
            \length ->
                JsFloat64Array.zeros length
                    |> JsTypedArray.buffer
                    |> JsArrayBuffer.length
                    |> Expect.equal (8 * length)
        ]


bufferOffset : Test
bufferOffset =
    describe "bufferOffset"
        [ fuzz TestFuzz.length "of fromBuffer is coherent" <|
            \offset ->
                JsArrayBuffer.zeros (offset + 1)
                    |> JsUint8Array.fromBuffer offset 1
                    |> Result.map JsTypedArray.bufferOffset
                    |> Expect.equal (Ok offset)
        , fuzz TestFuzz.length "of extracted is coherent" <|
            \offset ->
                JsUint8Array.zeros (offset + 1)
                    |> JsTypedArray.extract offset (offset + 1)
                    |> JsTypedArray.bufferOffset
                    |> Expect.equal offset
        , fuzz2 TestFuzz.length TestFuzz.length "of extracted twice is coherent" <|
            \offset1 offset2 ->
                JsUint8Array.zeros (offset1 + offset2 + 1)
                    |> JsTypedArray.extract offset1 (offset1 + offset2 + 1)
                    |> JsTypedArray.extract offset2 (offset2 + 1)
                    |> JsTypedArray.bufferOffset
                    |> Expect.equal (offset1 + offset2)
        ]


all : Test
all =
    describe "all"
        [ test "Elements of empty array verify any predicate" <|
            \_ ->
                JsUint8Array.zeros 0
                    |> JsTypedArray.all (\_ -> False)
                    |> Expect.true "Elements of empty array verify any predicate"
        , fuzz TestFuzz.length "True predicate on all elements returns True" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.all (\_ -> True)
                    |> Expect.true "True predicate on all elements returns True"
        , fuzz TestFuzz.length "False if predicate returns False one time" <|
            \length ->
                if length > 0 then
                    JsUint8Array.initialize length identity
                        |> JsTypedArray.all (\n -> n /= (length - 1) % 256)
                        |> Expect.false "False if predicate returns False one time"
                else
                    Expect.pass
        ]


indexedAll : Test
indexedAll =
    describe "indexedAll"
        [ test "Elements of empty array verify any predicate" <|
            \_ ->
                JsUint8Array.zeros 0
                    |> JsTypedArray.indexedAll (\_ _ -> False)
                    |> Expect.true "Elements of empty array verify any predicate"
        , fuzz TestFuzz.length "True predicate on all elements returns True" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedAll (\_ _ -> True)
                    |> Expect.true "True predicate on all elements returns True"
        , fuzz TestFuzz.length "False if predicate returns False one time" <|
            \length ->
                if length > 0 then
                    JsUint8Array.zeros length
                        |> JsTypedArray.indexedAll (\id _ -> id /= length - 1)
                        |> Expect.false "False if predicate returns False one time"
                else
                    Expect.pass
        ]


any : Test
any =
    describe "any"
        [ test "Empty array always returns false" <|
            \_ ->
                JsUint8Array.zeros 0
                    |> JsTypedArray.any (\_ -> True)
                    |> Expect.false "Empty array always returns false"
        , fuzz TestFuzz.length "False if predicates evaluates False on all elements" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.any (\_ -> False)
                    |> Expect.false "False if predicates evaluates False on all elements"
        , fuzz TestFuzz.length "True if predicate returns True one time" <|
            \length ->
                if length > 0 then
                    JsUint8Array.initialize length identity
                        |> JsTypedArray.any (\n -> n == (length - 1) % 256)
                        |> Expect.true "True if predicate returns True one time"
                else
                    Expect.pass
        ]


indexedAny : Test
indexedAny =
    describe "indexedAny"
        [ test "Empty array always returns false" <|
            \_ ->
                JsUint8Array.zeros 0
                    |> JsTypedArray.indexedAny (\_ _ -> True)
                    |> Expect.false "Empty array always returns false"
        , fuzz TestFuzz.length "False if predicates evaluates False on all elements" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedAny (\_ _ -> False)
                    |> Expect.false "False if predicates evaluates False on all elements"
        , fuzz TestFuzz.length "True if predicate returns True one time" <|
            \length ->
                if length > 0 then
                    JsUint8Array.zeros length
                        |> JsTypedArray.indexedAny (\id _ -> id == length - 1)
                        |> Expect.true "True if predicate returns True one time"
                else
                    Expect.pass
        ]


map : Test
map =
    describe "map"
        [ fuzz TestFuzz.length "map preserve length" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.map (\_ -> 42)
                    |> JsTypedArray.length
                    |> Expect.equal length
        , fuzz TestFuzz.length "map coherent" <|
            \length ->
                JsUint8Array.initialize length identity
                    |> JsTypedArray.map (\n -> n * n)
                    |> JsTypedArray.indexedAll (\id value -> id * id % 256 == value)
                    |> Expect.true "Squared values valid"
        ]


indexedMap : Test
indexedMap =
    describe "indexedMap"
        [ fuzz TestFuzz.length "indexedMap preserve length" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedMap (\_ _ -> 42)
                    |> JsTypedArray.length
                    |> Expect.equal length
        , fuzz TestFuzz.length "indexedMap coherent" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedMap (\id _ -> id)
                    |> JsTypedArray.indexedAll (\id value -> id % 256 == value)
                    |> Expect.true "All values set to index"
        ]


map2 : Test
map2 =
    describe "map2"
        [ fuzz2 TestFuzz.length TestFuzz.length "Result has length of smaller array" <|
            \l1 l2 ->
                let
                    typedArray1 =
                        JsUint8Array.zeros l1

                    typedArray2 =
                        JsUint8Array.zeros l2

                    resultArray =
                        JsTypedArray.map2 (\_ _ -> 42) typedArray1 typedArray2
                in
                JsTypedArray.length resultArray
                    |> Expect.equal (min l1 l2)
        , fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Map2 which keep only first array ok" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2
                in
                JsTypedArray.map2 (\first _ -> first) typedArray1 typedArray2
                    |> JsTypedArray.equal (JsTypedArray.extract 0 (min length1 length2) typedArray1)
                    |> Expect.true ""
        , fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Map2 which keep only second array ok" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2
                in
                JsTypedArray.map2 (\_ second -> second) typedArray1 typedArray2
                    |> JsTypedArray.equal (JsTypedArray.extract 0 (min length1 length2) typedArray2)
                    |> Expect.true ""
        ]


indexedMap2 : Test
indexedMap2 =
    describe "indexedMap2"
        [ fuzz2 TestFuzz.length TestFuzz.length "Result has length of smaller array" <|
            \l1 l2 ->
                let
                    typedArray1 =
                        JsUint8Array.zeros l1

                    typedArray2 =
                        JsUint8Array.zeros l2

                    resultArray =
                        JsTypedArray.indexedMap2 (\_ _ _ -> 42) typedArray1 typedArray2
                in
                JsTypedArray.length resultArray
                    |> Expect.equal (min l1 l2)
        , fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Map2 which keep only first array ok" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2
                in
                JsTypedArray.indexedMap2 (\_ first _ -> first) typedArray1 typedArray2
                    |> JsTypedArray.equal (JsTypedArray.extract 0 (min length1 length2) typedArray1)
                    |> Expect.true ""
        , fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Map2 which keep only second array ok" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2
                in
                JsTypedArray.indexedMap2 (\_ _ second -> second) typedArray1 typedArray2
                    |> JsTypedArray.equal (JsTypedArray.extract 0 (min length1 length2) typedArray2)
                    |> Expect.true ""
        ]


unsafeGetAt : Test
unsafeGetAt =
    describe "unsafeGetAt"
        [ fuzz2 TestFuzz.length Fuzz.int "Unsafely get value at random index" <|
            \length index ->
                if 0 <= index && index < length then
                    JsUint8Array.initialize length identity
                        |> JsTypedArray.unsafeGetAt index
                        |> Expect.equal (index % 256)
                else
                    -- Will throw a JavaScript error if called here
                    Expect.pass
        ]


getAt : Test
getAt =
    describe "getAt"
        [ fuzz2 TestFuzz.length Fuzz.int "Get value at random index" <|
            \length index ->
                if 0 <= index && index < length then
                    JsUint8Array.initialize length identity
                        |> JsTypedArray.getAt index
                        |> Expect.equal (Just <| index % 256)
                else
                    JsUint8Array.zeros length
                        |> JsTypedArray.getAt index
                        |> Expect.equal Nothing
        ]


findIndex : Test
findIndex =
    describe "findIndex"
        [ fuzz2 TestFuzz.length (Fuzz.intRange 0 255) "at random index" <|
            \length index ->
                if index < length then
                    JsUint8Array.initialize length identity
                        |> JsTypedArray.findIndex (\n -> n == index)
                        |> Expect.equal (Just index)
                else
                    JsUint8Array.initialize length identity
                        |> JsTypedArray.findIndex (\n -> n == index)
                        |> Expect.equal Nothing
        ]


indexedFindIndex : Test
indexedFindIndex =
    describe "indexedFindIndex"
        [ fuzz2 TestFuzz.length Fuzz.int "at random index" <|
            \length index ->
                if 0 <= index && index < length then
                    JsUint8Array.zeros length
                        |> JsTypedArray.indexedFindIndex (\id _ -> id == index)
                        |> Expect.equal (Just index)
                else
                    JsUint8Array.zeros length
                        |> JsTypedArray.indexedFindIndex (\id _ -> id == index)
                        |> Expect.equal Nothing
        ]


{-| Function reorganized by R. Feldman: [Discourse post][post]

[post]: https://discourse.elm-lang.org/t/why-isnt-there-a-simpler-expect-all-test/466

-}
filter : Test
filter =
    describe "filter"
        [ fuzz2 TestFuzz.length (Fuzz.intRange 0 255) "Sum of lengths equal original length" <|
            \length index ->
                let
                    { smaller, bigger } =
                        splitFilterArrays length index
                in
                (JsTypedArray.length smaller + JsTypedArray.length bigger)
                    |> Expect.equal length
        , fuzz2 TestFuzz.length (Fuzz.intRange 0 255) "Bigger array contains bigger elements according to JsTypedArray.all" <|
            \length index ->
                splitFilterArrays length index
                    |> .bigger
                    |> JsTypedArray.all (\num -> index < num)
                    |> Expect.true "All elements should have been bigger than their index in the array"
        , fuzz2 TestFuzz.length (Fuzz.intRange 0 255) "Smaller array contains smaller elements according to JsTypedArray.any" <|
            \length index ->
                splitFilterArrays length index
                    |> .smaller
                    |> JsTypedArray.any (\num -> index < num)
                    |> Expect.false "No elements should have been bigger than their index in the array"
        ]


indexedFilter : Test
indexedFilter =
    describe "indexedFilter"
        [ fuzz2 TestFuzz.length Fuzz.int "Filter out big indices" <|
            \length index ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedFilter (\id _ -> id < index)
                    |> JsTypedArray.length
                    |> Expect.equal (max 0 (min length index))
        , fuzz2 TestFuzz.length Fuzz.int "Filter out small indices" <|
            \length index ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedFilter (\id _ -> id >= index)
                    |> JsTypedArray.length
                    |> Expect.equal (length - max 0 (min length index))
        ]


extract : Test
extract =
    describe "extract"
        [ fuzz3 TestFuzz.length TestFuzz.length TestFuzz.length "with correct indices" <|
            \a b c ->
                case List.sort [ a, b, c ] of
                    l1 :: l2 :: l3 :: [] ->
                        JsUint8Array.initialize l3 identity
                            |> JsTypedArray.extract l1 l2
                            |> JsTypedArray.indexedAll (\id value -> value == (id + l1) % 256)
                            |> Expect.true "Values should correspond to index extracted"

                    _ ->
                        Expect.fail "This branch should never be called"
        , fuzz3 TestFuzz.length Fuzz.int Fuzz.int "with any indices" <|
            \length start end ->
                let
                    typedArray =
                        JsUint8Array.zeros length
                            |> JsTypedArray.indexedMap (\id _ -> id)

                    correctStart =
                        arrayIndex length start

                    correctEnd =
                        arrayIndex length end
                in
                JsTypedArray.extract correctStart correctEnd typedArray
                    |> JsTypedArray.equal (JsTypedArray.extract start end typedArray)
                    |> Expect.true "Both arrays should be equal"
        ]


append : Test
append =
    describe "append"
        [ fuzz2 (Fuzz.list Fuzz.int) (Fuzz.list Fuzz.int) "two arrays from lists" <|
            \list1 list2 ->
                let
                    typedArray1 =
                        JsUint8Array.fromList list1

                    typedArray2 =
                        JsUint8Array.fromList list2
                in
                JsTypedArray.append typedArray1 typedArray2
                    |> JsTypedArray.equal (JsUint8Array.fromList <| List.append list1 list2)
                    |> Expect.true "should equal array from appended list"
        ]


replaceWithConstant : Test
replaceWithConstant =
    fuzz4 TestFuzz.length Fuzz.int Fuzz.int Fuzz.int "replaceWithConstant" <|
        \length start end constant ->
            JsUint8Array.zeros length
                |> JsTypedArray.replaceWithConstant start end constant
                |> JsTypedArray.extract start end
                |> JsTypedArray.all ((==) (constant % 256))
                |> Expect.true "All extracted values should be equal to constant"


reverse : Test
reverse =
    describe "reverse"
        [ fuzz TestFuzz.jsUint8Array "has same length than original" <|
            \typedArray ->
                JsTypedArray.reverse typedArray
                    |> JsTypedArray.length
                    |> Expect.equal (JsTypedArray.length typedArray)
        , fuzz TestFuzz.jsUint8Array "is a symmetric application" <|
            \typedArray ->
                typedArray
                    |> JsTypedArray.reverse
                    |> JsTypedArray.reverse
                    |> JsTypedArray.equal typedArray
                    |> Expect.true "Double reverse should be identity"
        ]


sort : Test
sort =
    describe "sort"
        [ fuzz TestFuzz.jsUint8Array "keep array length" <|
            \typedArray ->
                JsTypedArray.sort typedArray
                    |> JsTypedArray.length
                    |> Expect.equal (JsTypedArray.length typedArray)
        , fuzz TestFuzz.jsUint8Array "is idempotent" <|
            \typedArray ->
                JsTypedArray.sort (JsTypedArray.sort typedArray)
                    |> JsTypedArray.equal (JsTypedArray.sort typedArray)
                    |> Expect.true "Second sorting should not change array"
        ]


reverseSort : Test
reverseSort =
    fuzz TestFuzz.jsUint8Array "reverseSort" <|
        \typedArray ->
            typedArray
                |> JsTypedArray.sort
                |> JsTypedArray.reverse
                |> JsTypedArray.equal (JsTypedArray.reverseSort typedArray)
                |> Expect.true "Sort then reverse should equal reverseSort"


foldl : Test
foldl =
    describe "foldl"
        [ fuzz TestFuzz.jsUint8Array "with (::) equals reverse" <|
            \typedArray ->
                JsTypedArray.foldl (::) [] typedArray
                    |> List.reverse
                    |> Expect.equal (JsTypedArray.toList typedArray)
        ]


indexedFoldl : Test
indexedFoldl =
    let
        unzippedFolded typedArray =
            typedArray
                |> JsTypedArray.indexedFoldl concatPair []
                |> List.unzip
    in
    describe "indexedFoldl"
        [ fuzz TestFuzz.jsUint8Array "unzipped first is reversed range" <|
            \typedArray ->
                unzippedFolded typedArray
                    |> Tuple.first
                    |> List.reverse
                    |> Expect.equal (List.range 0 <| JsTypedArray.length typedArray - 1)
        , fuzz TestFuzz.jsUint8Array "unzipped second is reversed array" <|
            \typedArray ->
                unzippedFolded typedArray
                    |> Tuple.second
                    |> List.reverse
                    |> Expect.equal (JsTypedArray.toList typedArray)
        ]


foldr : Test
foldr =
    describe "foldr"
        [ fuzz TestFuzz.jsUint8Array "is equivalent to foldl on reverse" <|
            \typedArray ->
                JsTypedArray.reverse typedArray
                    |> JsTypedArray.foldl (::) []
                    |> Expect.equal (JsTypedArray.foldr (::) [] typedArray)
        ]


indexedFoldr : Test
indexedFoldr =
    describe "indexedFoldr"
        [ fuzz TestFuzz.jsUint8Array "is equivalent to indexedFoldl on reverse" <|
            \typedArray ->
                let
                    concatPairRight =
                        concatPairReverse (JsTypedArray.length typedArray)
                in
                JsTypedArray.indexedFoldl concatPair [] (JsTypedArray.reverse typedArray)
                    |> Expect.equal (JsTypedArray.indexedFoldr concatPairRight [] typedArray)
        ]


foldl2 : Test
foldl2 =
    describe "foldl2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "on one array equals foldl" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2

                    newArray1 =
                        JsTypedArray.extract 0 (min length1 length2) typedArray1

                    newArray2 =
                        JsTypedArray.extract 0 (min length1 length2) typedArray2

                    fold2First =
                        JsTypedArray.foldl2 (\v1 _ acc -> v1 :: acc) [] typedArray1 typedArray2

                    fold2Second =
                        JsTypedArray.foldl2 (\_ v2 acc -> v2 :: acc) [] typedArray1 typedArray2

                    foldFirst =
                        JsTypedArray.foldl (::) [] newArray1

                    foldSecond =
                        JsTypedArray.foldl (::) [] newArray2
                in
                ( foldFirst, foldSecond )
                    |> Expect.equal ( fold2First, fold2Second )
        ]


indexedFoldl2 : Test
indexedFoldl2 =
    describe "indexedFoldl2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "on one array equals indexedFoldl" <|
            \typedArray1 typedArray2 ->
                let
                    fold2First =
                        JsTypedArray.indexedFoldl2 (\id v1 _ acc -> ( id, v1 ) :: acc) [] typedArray1 typedArray2

                    fold2Second =
                        JsTypedArray.indexedFoldl2 (\id _ v2 acc -> ( id, v2 ) :: acc) [] typedArray1 typedArray2

                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2

                    newArray1 =
                        JsTypedArray.extract 0 (min length1 length2) typedArray1

                    newArray2 =
                        JsTypedArray.extract 0 (min length1 length2) typedArray2

                    foldFirst =
                        JsTypedArray.indexedFoldl concatPair [] newArray1

                    foldSecond =
                        JsTypedArray.indexedFoldl concatPair [] newArray2
                in
                ( foldFirst, foldSecond )
                    |> Expect.equal ( fold2First, fold2Second )
        ]


foldr2 : Test
foldr2 =
    describe "foldr2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "is equivalent to foldl2 on reversed arrays" <|
            \typedArray1 typedArray2 ->
                let
                    reversed1 =
                        JsTypedArray.reverse typedArray1

                    reversed2 =
                        JsTypedArray.reverse typedArray2
                in
                JsTypedArray.foldr2 concatPair [] typedArray1 typedArray2
                    |> Expect.equal (JsTypedArray.foldl2 concatPair [] reversed1 reversed2)
        ]


indexedFoldr2 : Test
indexedFoldr2 =
    describe "indexedFoldr2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "is equivalent to indexedFoldl2 on reversed arrays" <|
            \typedArray1 typedArray2 ->
                let
                    reversed1 =
                        JsTypedArray.reverse typedArray1

                    reversed2 =
                        JsTypedArray.reverse typedArray2

                    newLength =
                        min (JsTypedArray.length typedArray1) (JsTypedArray.length typedArray2)

                    concatReverse =
                        concatTripletReverse newLength
                in
                JsTypedArray.indexedFoldr2 concatTriplet [] typedArray1 typedArray2
                    |> Expect.equal (JsTypedArray.indexedFoldl2 concatReverse [] reversed1 reversed2)
        ]


foldlr : Test
foldlr =
    describe "foldlr"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "is same as reverse second array" <|
            \typedArray1 typedArray2 ->
                JsTypedArray.foldl2 concatPair [] typedArray1 (JsTypedArray.reverse typedArray2)
                    |> Expect.equal (JsTypedArray.foldlr concatPair [] typedArray1 typedArray2)
        ]


join : Test
join =
    describe "join"
        [ fuzz TestFuzz.jsUint8Array "is equivalent to String.join on list" <|
            \typedArray ->
                JsTypedArray.toList typedArray
                    |> List.map toString
                    |> String.join ","
                    |> Expect.equal (JsTypedArray.join "," typedArray)
        ]



-- HELPERS ###########################################################


arrayIndex : Int -> Int -> Int
arrayIndex length idx =
    if idx < 0 then
        max 0 (length + idx)
    else
        idx


concatPair : Int -> Int -> List ( Int, Int ) -> List ( Int, Int )
concatPair x y acc =
    ( x, y ) :: acc


concatPairReverse : Int -> Int -> Int -> List ( Int, Int ) -> List ( Int, Int )
concatPairReverse length index value acc =
    ( length - 1 - index, value ) :: acc


concatTriplet : Int -> Int -> Int -> List ( Int, Int, Int ) -> List ( Int, Int, Int )
concatTriplet x y z acc =
    ( x, y, z ) :: acc


concatTripletReverse : Int -> Int -> Int -> Int -> List ( Int, Int, Int ) -> List ( Int, Int, Int )
concatTripletReverse length index x y acc =
    ( length - 1 - index, x, y ) :: acc


splitFilterArrays : Int -> Int -> { bigger : JsTypedArray Uint8 Int, smaller : JsTypedArray Uint8 Int }
splitFilterArrays length index =
    let
        rangeArray =
            JsUint8Array.initialize length identity

        biggerThanIndex n =
            index < n
    in
    { bigger = JsTypedArray.filter biggerThanIndex rangeArray
    , smaller = JsTypedArray.filter (not << biggerThanIndex) rangeArray
    }
