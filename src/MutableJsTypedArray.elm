module MutableJsTypedArray
    exposing
        ( MutableJsTypedArray
        , unsafeSet
        , unsafeSetAt
        )

{-| Experimental module for mutating operations on typed arrays.

@docs MutableJsTypedArray

@docs unsafeSetAt, unsafeSet

-}

import JsTypedArray exposing (JsTypedArray)
import Native.MutableJsTypedArray


{-| Mutable typed array.
-}
type alias MutableJsTypedArray a b =
    JsTypedArray a b


{-| Set value of typed array at given position.
-}
unsafeSetAt : Int -> b -> MutableJsTypedArray a b -> MutableJsTypedArray a b
unsafeSetAt =
    Native.MutableJsTypedArray.unsafeSetAt


{-| Set values of typed array according to given function of element index.
-}
unsafeSet : (Int -> b) -> MutableJsTypedArray a b -> MutableJsTypedArray a b
unsafeSet =
    Native.MutableJsTypedArray.unsafeSet
