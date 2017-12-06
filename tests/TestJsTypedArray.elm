module TestJsTypedArray
    exposing
        ( indexedAll
        , indexedAny
        )

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer)
import JsTypedArray
import JsUint8Array
import Test exposing (..)


lengthFuzzer : Fuzzer Int
lengthFuzzer =
    Fuzz.intRange 0 1000


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
