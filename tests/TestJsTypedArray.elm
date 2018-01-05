module TestJsTypedArray
    exposing
        ( all
        , any
        , equal
        , extract
        , filter
        , findIndex
        , foldl
        , foldl2
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
import JsTypedArray exposing (JsTypedArray, Uint8)
import JsUint8Array
import String
import Test exposing (..)
import TestFuzz


arrayIndex : Int -> Int -> Int
arrayIndex length idx =
    if idx < 0 then
        max 0 (length + idx)
    else
        idx


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
        [ fuzz2 TestFuzz.length (Fuzz.intRange 0 255) "Find at random index" <|
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
        [ fuzz2 TestFuzz.length Fuzz.int "Find at random index" <|
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


splitArrays : Int -> Int -> { bigger : JsTypedArray Uint8 Int, smaller : JsTypedArray Uint8 Int }
splitArrays length index =
    let
        rangeArray =
            JsUint8Array.initialize length identity

        biggerThanIndex n =
            index < n
    in
    { bigger = JsTypedArray.filter biggerThanIndex rangeArray
    , smaller = JsTypedArray.filter (not << biggerThanIndex) rangeArray
    }


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
                        splitArrays length index
                in
                (JsTypedArray.length smaller + JsTypedArray.length bigger)
                    |> Expect.equal length
        , fuzz2 TestFuzz.length (Fuzz.intRange 0 255) "Bigger array contains bigger elements according to JsTypedArray.all" <|
            \length index ->
                splitArrays length index
                    |> .bigger
                    |> JsTypedArray.all (\num -> index < num)
                    |> Expect.true "All elements should have been bigger than their index in the array"
        , fuzz2 TestFuzz.length (Fuzz.intRange 0 255) "Smaller array contains smaller elements according to JsTypedArray.any" <|
            \length index ->
                splitArrays length index
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
        [ fuzz3 TestFuzz.length TestFuzz.length TestFuzz.length "Extract with correct indices" <|
            \a b c ->
                case List.sort [ a, b, c ] of
                    l1 :: l2 :: l3 :: [] ->
                        JsUint8Array.initialize l3 identity
                            |> JsTypedArray.extract l1 l2
                            |> JsTypedArray.indexedAll (\id value -> value == (id + l1) % 256)
                            |> Expect.true "Values correspond to index extracted"

                    _ ->
                        Expect.fail "This branch is never called"
        , fuzz3 TestFuzz.length Fuzz.int Fuzz.int "Extract with any indices" <|
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
        [ fuzz TestFuzz.jsUint8Array "Reversed list has same length than original list" <|
            \typedArray ->
                JsTypedArray.reverse typedArray
                    |> JsTypedArray.length
                    |> Expect.equal (JsTypedArray.length typedArray)
        , fuzz TestFuzz.jsUint8Array "Reverse is a symmetric application" <|
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
        [ fuzz TestFuzz.jsUint8Array "Sorting keep array length" <|
            \typedArray ->
                JsTypedArray.sort typedArray
                    |> JsTypedArray.length
                    |> Expect.equal (JsTypedArray.length typedArray)
        , fuzz TestFuzz.jsUint8Array "Sorting is idempotent" <|
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
        [ fuzz TestFuzz.length "Length equals fold with (+1)" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.foldl (\_ v -> v + 1) 0
                    |> Expect.equal length
        , fuzz TestFuzz.length "Sum of zeros equals zero" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.foldl (+) 0
                    |> Expect.equal 0
        , fuzz TestFuzz.jsUint8Array "Cons foldl equals reverse" <|
            \typedArray ->
                typedArray
                    |> JsTypedArray.foldl (::) []
                    |> JsUint8Array.fromList
                    |> JsTypedArray.reverse
                    |> JsTypedArray.equal typedArray
                    |> Expect.true "Both arrays should be equal"
        ]


indexedFoldl : Test
indexedFoldl =
    describe "indexedFoldl"
        [ fuzz TestFuzz.length "Length equals fold with (+1)" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedFoldl (\_ _ v -> v + 1) 0
                    |> Expect.equal length
        , fuzz TestFuzz.length "Sum of zeros equals zero" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedFoldl (\_ v sum -> sum + v) 0
                    |> Expect.equal 0
        , fuzz TestFuzz.jsUint8Array "Cons foldl equals reverse" <|
            \typedArray ->
                typedArray
                    |> JsTypedArray.indexedFoldl (always (::)) []
                    |> JsUint8Array.fromList
                    |> JsTypedArray.reverse
                    |> JsTypedArray.equal typedArray
                    |> Expect.true "Both arrays should be equal"
        ]


foldr : Test
foldr =
    describe "foldr"
        [ fuzz TestFuzz.length "Length equals fold with (+1)" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.foldr (\_ v -> v + 1) 0
                    |> Expect.equal length
        , fuzz TestFuzz.length "Sum of zeros equals zero" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.foldr (+) 0
                    |> Expect.equal 0
        , fuzz TestFuzz.jsUint8Array "Cons foldr equals identity" <|
            \typedArray ->
                typedArray
                    |> JsTypedArray.foldr (::) []
                    |> JsUint8Array.fromList
                    |> JsTypedArray.equal typedArray
                    |> Expect.true "Both arrays should be equal"
        ]


indexedFoldr : Test
indexedFoldr =
    describe "indexedFoldr"
        [ fuzz TestFuzz.length "Length equals fold with (+1)" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedFoldr (\_ _ v -> v + 1) 0
                    |> Expect.equal length
        , fuzz TestFuzz.length "Sum of zeros equals zero" <|
            \length ->
                JsUint8Array.zeros length
                    |> JsTypedArray.indexedFoldr (\_ v sum -> sum + v) 0
                    |> Expect.equal 0
        , fuzz TestFuzz.jsUint8Array "Cons foldr equals identity" <|
            \typedArray ->
                typedArray
                    |> JsTypedArray.indexedFoldr (always (::)) []
                    |> JsUint8Array.fromList
                    |> JsTypedArray.equal typedArray
                    |> Expect.true "Both arrays should be equal"
        ]


foldl2 : Test
foldl2 =
    describe "foldl2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Foldl2 on one array equals foldl" <|
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
                        JsTypedArray.foldl2 (\v1 _ acc -> v1 + acc) 0 typedArray1 typedArray2

                    fold2Second =
                        JsTypedArray.foldl2 (\_ v2 acc -> v2 + acc) 0 typedArray1 typedArray2

                    foldFirst =
                        JsTypedArray.foldl (+) 0 newArray1

                    foldSecond =
                        JsTypedArray.foldl (+) 0 newArray2
                in
                ( foldFirst, foldSecond )
                    |> Expect.equal ( fold2First, fold2Second )
        ]


indexedFoldl2 : Test
indexedFoldl2 =
    describe "indexedFoldl2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Foldl2 on one array equals foldl" <|
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
                        JsTypedArray.indexedFoldl2 (\_ v1 _ acc -> v1 + acc) 0 typedArray1 typedArray2

                    fold2Second =
                        JsTypedArray.indexedFoldl2 (\_ _ v2 acc -> v2 + acc) 0 typedArray1 typedArray2

                    foldFirst =
                        JsTypedArray.indexedFoldl (always (+)) 0 newArray1

                    foldSecond =
                        JsTypedArray.indexedFoldl (always (+)) 0 newArray2
                in
                ( foldFirst, foldSecond )
                    |> Expect.equal ( fold2First, fold2Second )
        ]


foldr2 : Test
foldr2 =
    describe "foldr2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Foldr2 on one array equals foldr" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2

                    newLength =
                        min length1 length2

                    newArray1 =
                        JsTypedArray.extract (length1 - newLength) length1 typedArray1

                    newArray2 =
                        JsTypedArray.extract (length2 - newLength) length2 typedArray2

                    fold2First =
                        JsTypedArray.foldr2 (\v1 _ acc -> v1 + acc) 0 typedArray1 typedArray2

                    fold2Second =
                        JsTypedArray.foldr2 (\_ v2 acc -> v2 + acc) 0 typedArray1 typedArray2

                    foldFirst =
                        JsTypedArray.foldr (+) 0 newArray1

                    foldSecond =
                        JsTypedArray.foldr (+) 0 newArray2
                in
                ( foldFirst, foldSecond )
                    |> Expect.equal ( fold2First, fold2Second )
        ]


indexedFoldr2 : Test
indexedFoldr2 =
    describe "indexedFoldr2"
        [ fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Foldr2 on one array equals foldr" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2

                    newLength =
                        min length1 length2

                    newArray1 =
                        JsTypedArray.extract (length1 - newLength) length1 typedArray1

                    newArray2 =
                        JsTypedArray.extract (length2 - newLength) length2 typedArray2

                    fold2First =
                        JsTypedArray.indexedFoldr2 (\_ v1 _ acc -> v1 + acc) 0 typedArray1 typedArray2

                    fold2Second =
                        JsTypedArray.indexedFoldr2 (\_ _ v2 acc -> v2 + acc) 0 typedArray1 typedArray2

                    foldFirst =
                        JsTypedArray.indexedFoldr (always (+)) 0 newArray1

                    foldSecond =
                        JsTypedArray.indexedFoldr (always (+)) 0 newArray2
                in
                ( foldFirst, foldSecond )
                    |> Expect.equal ( fold2First, fold2Second )
        ]


join : Test
join =
    describe "join"
        [ fuzz TestFuzz.jsUint8Array "Joining is equal to fold with string concatenation" <|
            \typedArray ->
                let
                    separator =
                        ","

                    stringList =
                        typedArray
                            |> JsTypedArray.toList
                            |> List.map toString
                in
                JsTypedArray.join separator typedArray
                    |> Expect.equal (String.join separator stringList)
        ]
