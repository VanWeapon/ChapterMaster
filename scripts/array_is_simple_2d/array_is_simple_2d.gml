/// Helper function for serialize/deserialize methods to detect
/// complex datatypes that should probably have special handlers
function array_is_simple_2d(_array) {
	var _len = array_length(_array);
    for (var i = 0; i < _len; i++) {
        var val = _array[i];
        if (is_array(val)) {
            if (!array_is_simple(val)) {
				return false;
			}
        } else if (!(is_numeric(val) || is_string(val) || is_bool(val))) {
            return false;
        }
    }
    return true;
}