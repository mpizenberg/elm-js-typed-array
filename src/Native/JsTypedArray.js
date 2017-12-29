// import Maybe //

var _mpizenberg$elm_js_typed_array$Native_JsTypedArray = (function() {
  function length(typedArray) {
    return typedArray.length;
  }

  function getAt(index, typedArray) {
    return typedArray[index];
  }

  function buffer(typedArray) {
    return typedArray.buffer;
  }

  function bufferOffset(typedArray) {
    return typedArray.byteOffset;
  }

  function indexedAll(f, typedArray) {
    function flippedF(element, index) {
      return A2(f, index, element);
    }
    return typedArray.every(flippedF);
  }

  function indexedAny(f, typedArray) {
    function flippedF(element, index) {
      return A2(f, index, element);
    }
    return typedArray.some(flippedF);
  }

  function findIndex(f, typedArray) {
    function flippedF(element, index) {
      return A2(f, index, element);
    }
    var found = typedArray.findIndex(flippedF);
    if (found >= 0) {
      return _elm_lang$core$Maybe$Just(found);
    } else {
      return _elm_lang$core$Maybe$Nothing;
    }
  }

  function indexedFilter(f, typedArray) {
    function flippedF(element, index) {
      return A2(f, index, element);
    }
    return typedArray.filter(flippedF);
  }

  function extract(start, end, typedArray) {
    return typedArray.subarray(start, end);
  }

  function append(typedArray1, typedArray2) {
    var newTypedArray = new typedArray1.constructor(
      typedArray1.length + typedArray2.length
    );
    newTypedArray.set(typedArray1);
    newTypedArray.set(typedArray2, typedArray1.length);
    return newTypedArray;
  }

  function replaceWithConstant(start, end, constant, typedArray) {
    var copiedTypedArray = typedArray.slice();
    return copiedTypedArray.fill(constant, start, end);
  }

  function map(f, typedArray) {
    var length = typedArray.length;
    var newTypedArray = new typedArray.constructor(length);
    for (var i = 0; i < length; i++) {
      newTypedArray[i] = f(typedArray[i]);
    }
    return newTypedArray;
  }

  function map2(f, typedArray1, typedArray2) {
    var length = typedArray1.length;
    var newTypedArray = new typedArray1.constructor(length);
    for (var i = 0; i < length; i++) {
      newTypedArray[i] = A2(f, typedArray1[i], typedArray2[i]);
    }
    return newTypedArray;
  }

  function indexedMap(f, typedArray) {
    var length = typedArray.length;
    var newTypedArray = new typedArray.constructor(length);
    for (var i = 0; i < length; i++) {
      newTypedArray[i] = A2(f, i, typedArray[i]);
    }
    return newTypedArray;
  }

  function indexedMap2(f, typedArray1, typedArray2) {
    var length = typedArray1.length;
    var newTypedArray = new typedArray1.constructor(length);
    for (var i = 0; i < length; i++) {
      newTypedArray[i] = A3(f, i, typedArray1[i], typedArray2[i]);
    }
    return newTypedArray;
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
    function greaterThan(x, y) {
      return y - x;
    }
    var copiedTypedArray = typedArray.slice();
    return copiedTypedArray.sort(greaterThan);
  }

  function join(separator, typedArray) {
    return typedArray.join(separator);
  }

  function foldl(f, initialValue, typedArray) {
    var length = typedArray.length;
    var acc = initialValue;
    for (var i = 0; i < length; i++) {
      acc = A2(f, typedArray[i], acc);
    }
    return acc;
  }

  function indexedFoldl(f, initialValue, typedArray) {
    var length = typedArray.length;
    var acc = initialValue;
    for (var i = 0; i < length; i++) {
      acc = A3(f, i, typedArray[i], acc);
    }
    return acc;
  }

  function foldr(f, initialValue, typedArray) {
    var acc = initialValue;
    for (var i = typedArray.length - 1; i >= 0; i--) {
      acc = A2(f, typedArray[i], acc);
    }
    return acc;
  }

  function indexedFoldr(f, initialValue, typedArray) {
    var acc = initialValue;
    for (var i = typedArray.length - 1; i >= 0; i--) {
      acc = A3(f, i, typedArray[i], acc);
    }
    return acc;
  }

  function indexedFoldl2(f, initialValue, typedArray1, typedArray2) {
    function newF(accumulated, current, index) {
      return A4(f, index, current, typedArray2[index], accumulated);
    }
    return typedArray1.reduce(newF, initialValue);
  }

  function indexedFoldr2(f, initialValue, typedArray1, typedArray2) {
    function newF(accumulated, current, index) {
      return A4(f, index, current, typedArray2[index], accumulated);
    }
    return typedArray1.reduceRight(newF, initialValue);
  }

  function foldlr(f, initialValue, typedArray1, typedArray2) {
    const lastIndex = typedArray2.length - 1;
    function newF(accumulated, current, index) {
      return A3(f, current, typedArray2[lastIndex - index], accumulated);
    }
    return typedArray1.reduce(newF, initialValue);
  }

  return {
    length: length,
    getAt: F2(getAt),
    buffer: buffer,
    bufferOffset: bufferOffset,
    indexedAll: F2(indexedAll),
    indexedAny: F2(indexedAny),
    findIndex: F2(findIndex),
    indexedFilter: F2(indexedFilter),
    extract: F3(extract),
    append: F2(append),
    replaceWithConstant: F4(replaceWithConstant),
    map: F2(map),
    map2: F3(map2),
    indexedMap: F2(indexedMap),
    indexedMap2: F3(indexedMap2),
    reverse: reverse,
    sort: sort,
    reverseSort: reverseSort,
    join: F2(join),
    foldl: F3(foldl),
    foldr: F3(foldr),
    indexedFoldl: F3(indexedFoldl),
    indexedFoldr: F3(indexedFoldr),
    indexedFoldl2: F4(indexedFoldl2),
    indexedFoldr2: F4(indexedFoldr2),
    foldlr: F4(foldlr)
  };
})();
