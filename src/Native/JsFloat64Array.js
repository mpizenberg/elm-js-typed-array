var _mpizenberg$elm_js_typed_array$Native_JsFloat64Array = (function() {
  function zeros(length) {
    return new Float64Array(length);
  }

  function repeat(length, constant) {
    var typedArray = new Float64Array(length);
    return typedArray.fill(constant);
  }

  function initialize(length, f) {
    var typedArray = new Float64Array(length);
    for (var i = 0; i < length; i++) {
      typedArray[i] = f(i);
    }
    return typedArray;
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

  function fromTypedArray(typedArray) {
    var length = typedArray.length;
    var newTypedArray = new Float64Array(length);
    for (var i = 0; i < length; i++) {
      newTypedArray[i] = typedArray[i];
    }
    return newTypedArray;
  }

  return {
    zeros: zeros,
    repeat: F2(repeat),
    initialize: F2(initialize),
    fromBuffer: F3(fromBuffer),
    fromList: F2(fromList),
    fromTypedArray: fromTypedArray
  };
})();
