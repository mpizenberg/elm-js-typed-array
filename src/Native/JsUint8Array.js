var _mpizenberg$elm_js_typed_array$Native_JsUint8Array = function() {

  function initialize(length) { return new Uint8Array(length); }

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

  return {
    initialize : initialize,
    fromBuffer : F3(fromBuffer),
    fromList : F2(fromList),
  };
}
();
