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

  function fromValue(value) {
    if (!(value instanceof ArrayBuffer)) {
      return _elm_lang$core$Maybe$Nothing;
    } else {
      return _elm_lang$core$Maybe$Just(value);
    }
  }

  function encode(arrayBuffer) {
    return arrayBuffer;
  }

  function equal(arrayBuffer1, arrayBuffer2) {
    var typedArray1 = new Uint8Array(arrayBuffer1);
    var typedArray2 = new Uint8Array(arrayBuffer2);
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

  return {
    zeros: zeros,
    length: length,
    slice: F3(slice),
    fromValue: fromValue,
    encode: encode,
    equal: F2(equal)
  };
})();
