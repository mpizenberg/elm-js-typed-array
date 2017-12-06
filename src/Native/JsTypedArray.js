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

  return {
    length : length,
    getAt : F2(getAt),
    buffer : buffer,
    bufferOffset : bufferOffset,
    indexedAll : F2(indexedAll),
    indexedAny : F2(indexedAny),
  };
}
();
