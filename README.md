# JavaScript TypedArray API in elm

[![][badge-license]][license]

[badge-license]: https://img.shields.io/badge/license-MPL--2.0-blue.svg?style=flat-square
[license]: https://www.mozilla.org/en-US/MPL/2.0/


## Warnings

**WIP - Work In Progress - WIP** (well, on pause for now ...).

**This project contains "Native" (JS) code and is to be viewed
as a Web API exploration for elm,
not as "a piece of Native code you can use in production".**

Native (JS) code is going away in 0.19 so I emphasize again,
do not use this for production code.
To have more info about Native, Web APIs experimentations,
or collaboration for the elm language, checkout the following links:

* [(post) Richard Feldman, Building Trust: What Has Worked][richard-trust]
* [(post) Evan Czaplicki, What is "constructive" input?][evan-constructive]
* [(post) Evan Czaplicki, "Native Code" in 0.19][evan-native]

[richard-trust]: https://discourse.elm-lang.org/t/building-trust-what-has-worked/975
[evan-constructive]: https://discourse.elm-lang.org/t/what-is-constructive-input/977
[evan-native]: https://discourse.elm-lang.org/t/native-code-in-0-19/826


## Usage Goals

A global summary of the exploration is presented in
[this blog post][blog-post] on the elm discourse.

This library aims at providing the
[JavaScript `TypedArray` API][typed-array] in elm.
My reasons are two-fold:

1. Grow the cover of Web API in elm.
Typed arrays are use for ArrayBuffers, Blobs, Files, network exchange,
canvas data etc. So having them in elm is important in my opinion.
2. They are the only fixed-size, typed structures in JS. Due to this,
I'm convinced they can be used as a solid ground for fixed size
efficient mathematical (Linear Algebra) library.

[blog-post]: https://discourse.elm-lang.org/t/typed-arrays-for-elm/623
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
