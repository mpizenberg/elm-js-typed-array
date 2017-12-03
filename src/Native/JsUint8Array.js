var _mpizenberg$elm_js_typed_array$Native_JsUint8Array = function() {

function initialize( length ) {
	return new Uint8Array( length );
}

function fromBuffer( byteOffset, length, buffer ) {
	return new Uint8Array( buffer, byteOffset, length );
}

return {
	initialize: initialize,
	fromBuffer: F3(fromBuffer),
};

}();
