# JavaScript TypedArray API in elm

[![][badge-license]][license]

**Work In Progress - WIP**

This library aims at providing the
[JavaScript `TypedArray` API][typed-array] in elm.

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
 * be **flexible** yet **efficient**:
   * most functions are benchmarked and optimized
   * most functions are also provided in an "indexed" form
   * some functions have an "unsafe" form to avoid overcost of functor type returned


## Warnings

_It obviously contains some JS code and thus cannot be published
in elm official packages repository._
