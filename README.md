# JavaScript TypedArray API in elm

[![][badge-license]][license]

**Work In Progress - WIP**

This library aims at providing the
[JavaScript `TypedArray` API][typed-array] in elm.
My reasons are two-fold:

1. Grow the cover of Web API in elm.
Typed arrays are use for ArrayBuffers, Blobs, Files, network exchange,
canvas data etc. So having them in elm is important in my opinion.
2. They are the only fixed-size, typed structures in JS. Due to this,
I'm convinced they can be used as a solid ground for fixed size
efficient mathematical (Linear Algebra) library.


[badge-license]: https://img.shields.io/badge/license-MPL--2.0-blue.svg?style=flat-square
[license]: https://www.mozilla.org/en-US/MPL/2.0/
[typed-array]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Typed_arrays


## Design Goals

 * cover **full `TypedArray` API** (except few bits that don't make sense in elm)
 * be **elm compliant**:
   * appear as immutable data structure: modification create copies
   * type safe polymorphism: add phantom types
 * be **interoperable** with elm data structures:
   * from elm data structures: `fromList`, `fromArray`
   * to elm data structures: `toList`, `toArray`
 * be interoperable with JavaScript: 0-cost encoders / decoders
 * be as **minimalist** as possible. It aims to follow the successful approach
   of [Skinney/elm-array-exploration] which splits its array implementation in two parts.
   First a minimal wrapper of JavaScript array in native code (`Native/JsArray.js`
   and `Array/JsArray.elm`),
   and second, a pure elm implementation on top of it (`Array/Hamt.elm`).
 * be **flexible** yet **efficient**:
   * most functions are benchmarked and optimized
   * most functions are also provided in an "indexed" form
   * some functions have an "unsafe" form to avoid overcost of functor type returned

[Skinney/elm-array-exploration]: https://github.com/Skinney/elm-array-exploration

## Warnings

_It obviously contains some JS code and thus cannot be published
in elm official packages repository._
