var _mpizenberg$elm_js_typed_array$Native_JsFloat64Array = (function() {
  function zeros(length) {
    return new Float64Array(length);
  }

  function fromBuffer(byteOffset, length, buffer) {
    return new Float64Array(buffer, byteOffset, length);
  }

  function fromList(length, list) {
    var i = 0;
    var typedArray = new Float64Array(length);
    while (i < length) {
      typedArray[i] = list._0;
      list = list._1;
      i++;
    }
    return typedArray;
  }

  return {
    zeros: zeros,
    fromBuffer: F3(fromBuffer),
    fromList: F2(fromList)
  };
})();
