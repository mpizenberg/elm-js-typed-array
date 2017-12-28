var _mpizenberg$elm_js_typed_array$Native_JsArrayBuffer = (function() {
  function zeros(length) {
    return new ArrayBuffer(length);
  }

  function length(arrayBuffer) {
    return arrayBuffer.byteLength;
  }

  function slice(begin, end, arrayBuffer) {
    return arrayBuffer.slice(begin, end);
  }

  return {
    zeros: zeros,
    length: length,
    slice: F3(slice)
  };
})();
