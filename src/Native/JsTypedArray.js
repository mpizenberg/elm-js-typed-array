// import Maybe //

var _mpizenberg$elm_js_typed_array$Native_JsTypedArray = function() {

  function length(typedArray) { return typedArray.length; }

  function getAt(index, typedArray) { return typedArray[index]; }

  function buffer(typedArray) { return typedArray.buffer; }

  function bufferOffset(typedArray) { return typedArray.byteOffset; }

  function indexedAll(f, typedArray) {
    function flippedF(element, index) { return A2(f, index, element); }
    return typedArray.every(flippedF);
  }

  function indexedAny(f, typedArray) {
    function flippedF(element, index) { return A2(f, index, element); }
    return typedArray.some(flippedF);
  }

  function findIndex(f, typedArray) {
    function flippedF(element, index) { return A2(f, index, element); }
    var found = typedArray.findIndex(flippedF);
    if (found >= 0) {
      return _elm_lang$core$Maybe$Just(found);
    } else {
      return _elm_lang$core$Maybe$Nothing;
    }
  }

  function indexedFilter(f, typedArray) {
    function flippedF(element, index) { return A2(f, index, element); }
    return typedArray.filter(flippedF);
  }

  function extract(start, end, typedArray) {
    return typedArray.subarray(start, end);
  }

  function replaceWithConstant(start, end, constant, typedArray) {
    var copiedTypedArray = typedArray.slice();
    return copiedTypedArray.fill(constant, start, end);
  }

  function indexedMap(f, typedArray) {
    function flippedF(element, index) { return A2(f, index, element); }
    var copiedTypedArray = typedArray.slice();
    return copiedTypedArray.map(flippedF);
  }

  function reverse(typedArray) {
    var copiedTypedArray = typedArray.slice();
    return copiedTypedArray.reverse();
  }

  function sort(typedArray) {
    var copiedTypedArray = typedArray.slice();
    return copiedTypedArray.sort();
  }

  function reverseSort(typedArray) {
    function greaterThan(x, y) { return (y - x); }
    var copiedTypedArray = typedArray.slice();
    return copiedTypedArray.sort(greaterThan);
  }

  function join(separator, typedArray) { return typedArray.join(separator); }

  function indexedFoldl(f, initialValue, typedArray) {
    function flippedF(previous, current, index) {
      return A3(f, index, current, previous);
    }
    return typedArray.reduce(flippedF, initialValue);
  }

  function indexedFoldr(f, initialValue, typedArray) {
    function flippedF(previous, current, index) {
      return A3(f, index, current, previous);
    }
    return typedArray.reduceRight(flippedF, initialValue);
  }

  return {
    length : length,
    getAt : F2(getAt),
    buffer : buffer,
    bufferOffset : bufferOffset,
    indexedAll : F2(indexedAll),
    indexedAny : F2(indexedAny),
    findIndex : F2(findIndex),
    indexedFilter : F2(indexedFilter),
    extract : F3(extract),
    replaceWithConstant : F4(replaceWithConstant),
    indexedMap : F2(indexedMap),
    reverse : reverse,
    sort : sort,
    reverseSort : reverseSort,
    join : F2(join),
    indexedFoldl : F3(indexedFoldl),
    indexedFoldr : F3(indexedFoldr),
  };
}
();
