var _mpizenberg$elm_js_typed_array$Native_MutableJsDataView = (function() {
  function setInt8(offset, value, dataView) {
    dataView.setInt8(offset, value);
    return dataView;
  }

  function setUint8(offset, value, dataView) {
    dataView.setUint8(offset, value);
    return dataView;
  }

  function setInt16(offset, value, dataView) {
    dataView.setInt16(offset, value);
    return dataView;
  }

  function setUint16(offset, value, dataView) {
    dataView.setUint16(offset, value);
    return dataView;
  }

  function setInt32(offset, value, dataView) {
    dataView.setInt32(offset, value);
    return dataView;
  }

  function setUint32(offset, value, dataView) {
    dataView.setUint32(offset, value);
    return dataView;
  }

  function setFloat32(offset, value, dataView) {
    dataView.setFloat32(offset, value);
    return dataView;
  }

  function setFloat64(offset, value, dataView) {
    dataView.setFloat64(offset, value);
    return dataView;
  }

  return {
    setInt8: F3(setInt8),
    setUint8: F3(setUint8),
    setInt16: F3(setInt16),
    setUint16: F3(setUint16),
    setInt32: F3(setInt32),
    setUint32: F3(setUint32),
    setFloat32: F3(setFloat32),
    setFloat64: F3(setFloat64)
  };
})();
