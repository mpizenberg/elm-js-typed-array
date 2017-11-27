var _mpizenberg$elm_typed_array_exploration$Native_JsArrayBuffer = function() {

function initialize( length ) {
	return new ArrayBuffer( length );
}

function length( arrayBuffer ) {
	return arrayBuffer.byteLength;
}

function slice( begin, end, arrayBuffer ) {
	return arrayBuffer.slice( begin, end );
}

return {
    initialize: initialize,
    length: length,
    slice: F3(slice),
};

}();
