var _mpizenberg$elm_js_typed_array$Native_JsTypedArray = function() {

  function length(typedArray) { return typedArray.length; }

  function buffer(typedArray) { return typedArray.buffer; }

  function bufferOffset(typedArray) { return typedArray.byteOffset; }

  function all(f, typedArray) {
    function flippedF(element, index) { return A2(f, index, element); }
    return typedArray.every(flippedF);
  }

  function any(f, typedArray) {
    function flippedF(element, index) { return A2(f, index, element); }
    return typedArray.some(flippedF);
  }

  return {
    length : length,
    buffer : buffer,
    bufferOffset : bufferOffset,
    all : F2(all),
    any : F2(any),
  };
}
();
