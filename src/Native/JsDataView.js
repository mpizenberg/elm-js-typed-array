var _mpizenberg$elm_js_typed_array$Native_JsDataView = (function() {
  function empty() {
    var buffer = new ArrayBuffer(0);
    var dataView = new DataView(buffer);
    return dataView;
  }

  function fromBuffer(offset, length, buffer) {
    return new DataView(buffer, offset, length);
  }

  function buffer(dataView) {
    return dataView.buffer;
  }

  function byteLength(dataView) {
    return dataView.byteLength;
  }

  function byteOffset(dataView) {
    return dataView.byteOffset;
  }

  function getInt8(offset, dataView) {
    return dataView.getInt8(offset);
  }

  function getUint8(offset, dataView) {
    return dataView.getUint8(offset);
  }

  function getInt16(offset, dataView) {
    return dataView.getInt16(offset);
  }

  function getUint16(offset, dataView) {
    return dataView.getUint16(offset);
  }

  function getInt32(offset, dataView) {
    return dataView.getInt32(offset);
  }

  function getUint32(offset, dataView) {
    return dataView.getUint32(offset);
  }

  function getFloat32(offset, dataView) {
    return dataView.getFloat32(offset);
  }

  function getFloat64(offset, dataView) {
    return dataView.getFloat64(offset);
  }

  return {
    empty: empty,
    fromBuffer: F3(fromBuffer),
    buffer: buffer,
    byteLength: byteLength,
    byteOffset: byteOffset,
    getInt8: F2(getInt8),
    getUint8: F2(getUint8),
    getInt16: F2(getInt16),
    getUint16: F2(getUint16),
    getInt32: F2(getInt32),
    getUint32: F2(getUint32),
    getFloat32: F2(getFloat32),
    getFloat64: F2(getFloat64)
  };
})();
