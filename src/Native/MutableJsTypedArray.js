// import Maybe //

var _mpizenberg$elm_js_typed_array$Native_MutableJsTypedArray = (function() {
  function unsafeSetAt(index, value, typedArray) {
    typedArray[index] = value;
    return typedArray;
  }

  function unsafeSet(f, typedArray) {
    var length = typedArray.length;
    for (var i = 0; i < length; i++) {
      typedArray[i] = f(i);
    }
    return typedArray;
  }

  return {
    unsafeSetAt: F3(unsafeSetAt),
    unsafeSet: F2(unsafeSet)
  };
})();
