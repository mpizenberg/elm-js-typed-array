module TestJsTypedArray
    exposing
        ( extract
        , findIndex
        , getAt
        , indexedAll
        , indexedAny
        , indexedFilter
        , indexedFoldl
        , indexedFoldr
        , indexedMap
        , indexedMap2
        , join
        , replaceWithConstant
        , reverse
        , reverseSort
        , sort
        )

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsTypedArray
import JsUint8Array
import String
import Test exposing (..)
import TestFuzz


lengthFuzzer : Fuzzer Int
lengthFuzzer =
    Fuzz.intRange 0 1000


arrayIndex : Int -> Int -> Int
arrayIndex length idx =
    if idx < 0 then
        max 0 (length - idx)
    else
        idx


indexedAll : Test
indexedAll =
    describe "indexedAll"
        [ test "Elements of empty array verify any predicate" <|
            \_ ->
                JsUint8Array.initialize 0
                    |> JsTypedArray.indexedAll (\_ _ -> False)
                    |> Expect.true "Elements of empty array verify any predicate"
        , fuzz lengthFuzzer "True predicate on all elements returns True" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedAll (\_ _ -> True)
                    |> Expect.true "True predicate on all elements returns True"
        , fuzz lengthFuzzer "Returns False if predicate returns False one time" <|
            \length ->
                if length > 0 then
                    JsUint8Array.initialize length
                        |> JsTypedArray.indexedAll (\id _ -> id /= length - 1)
                        |> Expect.false "Returns False if predicate returns False one time"
                else
                    Expect.pass
        ]


indexedAny : Test
indexedAny =
    describe "indexedAny"
        [ test "Empty array always returns false" <|
            \_ ->
                JsUint8Array.initialize 0
                    |> JsTypedArray.indexedAny (\_ _ -> True)
                    |> Expect.false "Empty array always returns false"
        , fuzz lengthFuzzer "False if predicates evaluates False on all elements" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedAny (\_ _ -> False)
                    |> Expect.false "False if predicates evaluates False on all elements"
        , fuzz lengthFuzzer "Returns True if predicate returns True one time" <|
            \length ->
                if length > 0 then
                    JsUint8Array.initialize length
                        |> JsTypedArray.indexedAny (\id _ -> id == length - 1)
                        |> Expect.true "Returns False if predicate returns False one time"
                else
                    Expect.pass
        ]


indexedMap : Test
indexedMap =
    describe "indexedMap"
        [ fuzz lengthFuzzer "indexedMap preserve length" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedMap (\_ _ -> 42)
                    |> JsTypedArray.length
                    |> Expect.equal length
        , fuzz lengthFuzzer "indexedMap coherent" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedMap (\id _ -> id)
                    |> JsTypedArray.indexedAll (\id value -> id % 256 == value)
                    |> Expect.true "All values set to index"
        ]


indexedMap2 : Test
indexedMap2 =
    describe "indexedMap2"
        [ fuzz2 lengthFuzzer lengthFuzzer "Result has length of smaller array" <|
            \l1 l2 ->
                let
                    typedArray1 =
                        JsUint8Array.initialize l1

                    typedArray2 =
                        JsUint8Array.initialize l2

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
                    |> Expect.equal (JsTypedArray.extract 0 (min length1 length2) typedArray1)
        , fuzz2 TestFuzz.jsUint8Array TestFuzz.jsUint8Array "Map2 which keep only second array ok" <|
            \typedArray1 typedArray2 ->
                let
                    length1 =
                        JsTypedArray.length typedArray1

                    length2 =
                        JsTypedArray.length typedArray2
                in
                JsTypedArray.indexedMap2 (\_ _ second -> second) typedArray1 typedArray2
                    |> Expect.equal (JsTypedArray.extract 0 (min length1 length2) typedArray2)
        ]


getAt : Test
getAt =
    describe "getAt"
        [ fuzz2 lengthFuzzer Fuzz.int "Get value at random index" <|
            \length index ->
                if 0 <= index && index < length then
                    JsUint8Array.initialize length
                        |> JsTypedArray.indexedMap (\id _ -> id)
                        |> JsTypedArray.getAt index
                        |> Expect.equal (Just <| index % 256)
                else
                    JsUint8Array.initialize length
                        |> JsTypedArray.getAt index
                        |> Expect.equal Nothing
        ]


findIndex : Test
findIndex =
    describe "findIndex"
        [ fuzz2 lengthFuzzer Fuzz.int "Find at random index" <|
            \length index ->
                if 0 <= index && index < length then
                    JsUint8Array.initialize length
                        |> JsTypedArray.findIndex (\id _ -> id == index)
                        |> Expect.equal (Just index)
                else
                    JsUint8Array.initialize length
                        |> JsTypedArray.findIndex (\id _ -> id == index)
                        |> Expect.equal Nothing
        ]


indexedFilter : Test
indexedFilter =
    describe "indexedFilter"
        [ fuzz2 lengthFuzzer Fuzz.int "Filter out big indices" <|
            \length index ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedFilter (\id _ -> id < index)
                    |> JsTypedArray.length
                    |> Expect.equal (max 0 (min length index))
        , fuzz2 lengthFuzzer Fuzz.int "Filter out small indices" <|
            \length index ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedFilter (\id _ -> id >= index)
                    |> JsTypedArray.length
                    |> Expect.equal (length - max 0 (min length index))
        ]


extract : Test
extract =
    describe "extract"
        [ fuzz3 lengthFuzzer lengthFuzzer lengthFuzzer "Extract with correct indices" <|
            \a b c ->
                case List.sort [ a, b, c ] of
                    l1 :: l2 :: l3 :: [] ->
                        JsUint8Array.initialize l3
                            |> JsTypedArray.indexedMap (\id _ -> id)
                            |> JsTypedArray.extract l1 l2
                            |> JsTypedArray.indexedAll (\id value -> value == (id + l1) % 256)
                            |> Expect.true "Values correspond to index extracted"

                    _ ->
                        Expect.fail "This branch is never called"
        , fuzz3 lengthFuzzer lengthFuzzer lengthFuzzer "Extract with any indices" <|
            \length start end ->
                let
                    typedArray =
                        JsUint8Array.initialize length
                            |> JsTypedArray.indexedMap (\id _ -> id)

                    correctStart =
                        arrayIndex length start

                    correctEnd =
                        arrayIndex length end
                in
                JsTypedArray.extract start end typedArray
                    |> Expect.equal (JsTypedArray.extract correctStart correctEnd typedArray)
        ]


replaceWithConstant : Test
replaceWithConstant =
    fuzz4 lengthFuzzer Fuzz.int Fuzz.int Fuzz.int "replaceWithConstant" <|
        \length start end constant ->
            JsUint8Array.initialize length
                |> JsTypedArray.replaceWithConstant start end constant
                |> JsTypedArray.extract start end
                |> JsTypedArray.indexedAll (\_ value -> value == constant % 256)
                |> Expect.true "Replaced value are correct"


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
                    |> Expect.equal typedArray
        ]


sort : Test
sort =
    describe "sort"
        [ fuzz TestFuzz.jsUint8Array "Sorting keep array length" <|
            \typedArray ->
                JsTypedArray.reverse typedArray
                    |> JsTypedArray.length
                    |> Expect.equal (JsTypedArray.length typedArray)
        , fuzz TestFuzz.jsUint8Array "Sorting is idempotent" <|
            \typedArray ->
                let
                    sortedArray =
                        JsTypedArray.sort typedArray
                in
                JsTypedArray.sort sortedArray
                    |> Expect.equal sortedArray
        ]


reverseSort : Test
reverseSort =
    fuzz TestFuzz.jsUint8Array "Reverse sort equals sort then reverse" <|
        \typedArray ->
            typedArray
                |> JsTypedArray.sort
                |> JsTypedArray.reverse
                |> Expect.equal (JsTypedArray.reverseSort typedArray)


indexedFoldl : Test
indexedFoldl =
    describe "indexedFoldl"
        [ fuzz lengthFuzzer "Length equals fold with (+1)" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedFoldl (\_ _ v -> v + 1) 0
                    |> Expect.equal length
        , fuzz lengthFuzzer "Sum of zeros equals zero" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedFoldl (\_ v sum -> sum + v) 0
                    |> Expect.equal 0
        , fuzz TestFuzz.jsUint8Array "Cons foldl equals reverse" <|
            \typedArray ->
                typedArray
                    |> JsTypedArray.indexedFoldl (always (::)) []
                    |> JsUint8Array.fromList
                    |> JsTypedArray.reverse
                    |> Expect.equal typedArray
        ]


indexedFoldr : Test
indexedFoldr =
    describe "indexedFoldr"
        [ fuzz lengthFuzzer "Length equals fold with (+1)" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedFoldr (\_ _ v -> v + 1) 0
                    |> Expect.equal length
        , fuzz lengthFuzzer "Sum of zeros equals zero" <|
            \length ->
                JsUint8Array.initialize length
                    |> JsTypedArray.indexedFoldr (\_ v sum -> sum + v) 0
                    |> Expect.equal 0
        , fuzz TestFuzz.jsUint8Array "Cons foldr equals identity" <|
            \typedArray ->
                typedArray
                    |> JsTypedArray.indexedFoldr (always (::)) []
                    |> JsUint8Array.fromList
                    |> Expect.equal typedArray
        ]


join : Test
join =
    describe "join"
        [ fuzz TestFuzz.jsUint8Array "Joining is equal to fold with string concatenation" <|
            \typedArray ->
                let
                    separator =
                        ','

                    joinedArray : String
                    joinedArray =
                        JsTypedArray.join separator typedArray

                    accFunction : Int -> a -> List String -> List String
                    accFunction _ num numStrList =
                        if List.isEmpty numStrList then
                            [ toString num ]
                        else
                            toString num :: String.fromChar separator :: numStrList

                    foldedArray : List String
                    foldedArray =
                        JsTypedArray.indexedFoldr accFunction [] typedArray
                in
                joinedArray
                    |> Expect.equal (String.concat foldedArray)
        ]
