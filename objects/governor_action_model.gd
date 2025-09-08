class_name GovernorActionModel extends Object

var _governors: Array[Governor]:
	get = get_governors, set = set_governors

## Governors ##
func get_governors() -> Array[Governor]:
	return _governors


func set_governors(value: Array[Governor]):
	_governors = value


func get_governor_dicts() -> Array:
	var result = []
	for governor: Governor in _governors:
		result.append(governor.get_dict())	
	return result


func set_governor_dicts(governor_dicts: Array) -> void:
	fill_governors(governor_dicts)


func fill_governors(governor_array: Array) -> void:
	_governors.clear()
	for governor_dict: Dictionary in governor_array:
		_governors.append(Governor.new(governor_dict.get("name"), governor_dict.get("sensor")))
