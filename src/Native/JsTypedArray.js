// import Maybe //

var _mpizenberg$elm_js_typed_array$Native_JsTypedArray = (function() {
  function encode(typedArray) {
    return typedArray;
  }

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

  function all(f, typedArray) {
    var length = typedArray.length;
    var allTrue = true;
    var index = 0;
    while (allTrue && index < length) {
      allTrue = f(typedArray[index]);
      index++;
    }
    return allTrue;
  }

  function indexedAll(f, typedArray) {
    var length = typedArray.length;
    var allTrue = true;
    var index = 0;
    while (allTrue && index < length) {
      allTrue = A2(f, index, typedArray[index]);
      index++;
    }
    return allTrue;
  }

  function any(f, typedArray) {
    var length = typedArray.length;
    var anyTrue = false;
    var index = 0;
    while (!anyTrue && index < length) {
      anyTrue = f(typedArray[index]);
      index++;
    }
    return anyTrue;
  }

  function indexedAny(f, typedArray) {
    var length = typedArray.length;
    var anyTrue = false;
    var index = 0;
    while (!anyTrue && index < length) {
      anyTrue = A2(f, index, typedArray[index]);
      index++;
    }
    return anyTrue;
  }

  function findIndex(f, typedArray) {
    var length = typedArray.length;
    var found = false;
    var index = 0;
    while (!found && index < length) {
      found = f(typedArray[index]);
      index++;
    }
    if (found) {
      return _elm_lang$core$Maybe$Just(index - 1);
    } else {
      return _elm_lang$core$Maybe$Nothing;
    }
  }

  function indexedFindIndex(f, typedArray) {
    var length = typedArray.length;
    var found = false;
    var index = 0;
    while (!found && index < length) {
      found = A2(f, index, typedArray[index]);
      index++;
    }
    if (found) {
      return _elm_lang$core$Maybe$Just(index - 1);
    } else {
      return _elm_lang$core$Maybe$Nothing;
    }
  }

  function filter(f, typedArray) {
    var length = typedArray.length;
    var temporaryArray = new Array(0);
    var currentValue = null;
    for (var i = 0; i < length; i++) {
      currentValue = typedArray[i];
      if (f(currentValue)) {
        temporaryArray.push(currentValue);
      }
    }
    return new typedArray.constructor(temporaryArray);
  }

  function indexedFilter(f, typedArray) {
    var length = typedArray.length;
    var temporaryArray = new Array(0);
    var currentValue = null;
    for (var i = 0; i < length; i++) {
      currentValue = typedArray[i];
      if (A2(f, i, currentValue)) {
        temporaryArray.push(currentValue);
      }
    }
    return new typedArray.constructor(temporaryArray);
  }

  function equal(typedArray1, typedArray2) {
    var length1 = typedArray1.length;
    var length2 = typedArray2.length;
    var result = false;
    if (length1 === length2) {
      var allEqual = true;
      var index = 0;
      while (allEqual && index < length1) {
        allEqual = typedArray1[index] === typedArray2[index];
        index++;
      }
      result = allEqual;
    }
    return result;
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

  function indexedMap(f, typedArray) {
    var length = typedArray.length;
    var newTypedArray = new typedArray.constructor(length);
    for (var i = 0; i < length; i++) {
      newTypedArray[i] = A2(f, i, typedArray[i]);
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

  function foldl2(f, initialValue, typedArray1, typedArray2) {
    var length = typedArray1.length;
    var acc = initialValue;
    for (var i = 0; i < length; i++) {
      acc = A3(f, typedArray1[i], typedArray2[i], acc);
    }
    return acc;
  }

  function indexedFoldl2(f, initialValue, typedArray1, typedArray2) {
    var length = typedArray1.length;
    var acc = initialValue;
    for (var i = 0; i < length; i++) {
      acc = A4(f, i, typedArray1[i], typedArray2[i], acc);
    }
    return acc;
  }

  function foldr2(f, initialValue, typedArray1, typedArray2) {
    var acc = initialValue;
    for (var i = typedArray1.length - 1; i >= 0; i--) {
      acc = A3(f, typedArray1[i], typedArray2[i], acc);
    }
    return acc;
  }

  function indexedFoldr2(f, initialValue, typedArray1, typedArray2) {
    var acc = initialValue;
    for (var i = typedArray1.length - 1; i >= 0; i--) {
      acc = A4(f, i, typedArray1[i], typedArray2[i], acc);
    }
    return acc;
  }

  function foldlr(f, initialValue, typedArray1, typedArray2) {
    var length = typedArray1.length;
    var acc = initialValue;
    for (var i = 0; i < length; i++) {
      acc = A3(f, typedArray1[i], typedArray2[length - 1 - i], acc);
    }
    return acc;
  }

  return {
    encode: encode,
    length: length,
    getAt: F2(getAt),
    buffer: buffer,
    bufferOffset: bufferOffset,
    all: F2(all),
    any: F2(any),
    findIndex: F2(findIndex),
    filter: F2(filter),
    indexedAll: F2(indexedAll),
    indexedAny: F2(indexedAny),
    indexedFindIndex: F2(indexedFindIndex),
    indexedFilter: F2(indexedFilter),
    equal: F2(equal),
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
    foldl2: F4(foldl2),
    foldr2: F4(foldr2),
    foldlr: F4(foldlr),
    indexedFoldl: F3(indexedFoldl),
    indexedFoldr: F3(indexedFoldr),
    indexedFoldl2: F4(indexedFoldl2),
    indexedFoldr2: F4(indexedFoldr2)
  };
})();
