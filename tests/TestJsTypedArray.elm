module TestJsTypedArray
    exposing
        ( extract
        , indexedAll
        , indexedAny
        , indexedMap
        )

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsTypedArray
import JsUint8Array
import Test exposing (..)


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
