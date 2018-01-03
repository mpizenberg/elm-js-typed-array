var _mpizenberg$elm_js_typed_array$Native_JsUint8Array = (function() {
  function zeros(length) {
    return new Uint8Array(length);
  }

  function repeat(length, constant) {
    var typedArray = new Uint8Array(length);
    return typedArray.fill(constant);
  }

  function initialize(length, f) {
    var typedArray = new Uint8Array(length);
    for (var i = 0; i < length; i++) {
      typedArray[i] = f(i);
    }
    return typedArray;
  }

  function fromBuffer(byteOffset, length, buffer) {
    return new Uint8Array(buffer, byteOffset, length);
  }

  function fromList(length, list) {
    var i = 0;
    var typedArray = new Uint8Array(length);
    while (i < length) {
      typedArray[i] = list._0;
      list = list._1;
      i++;
    }
    return typedArray;
  }

  function fromTypedArray(typedArray) {
    var length = typedArray.length;
    var newTypedArray = new Uint8Array(length);
    for (var i = 0; i < length; i++) {
      newTypedArray[i] = typedArray[i];
    }
    return newTypedArray;
  }

  function fromValue(value) {
    if (!(value instanceof Uint8Array)) {
      throw "This is not an Uint8Array";
    }
    return value;
  }

  return {
    zeros: zeros,
    repeat: F2(repeat),
    initialize: F2(initialize),
    fromBuffer: F3(fromBuffer),
    fromList: F2(fromList),
    fromTypedArray: fromTypedArray,
    fromValue: fromValue
  };
})();
