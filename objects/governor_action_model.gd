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


func set_governor_dicts(governor_dicts: Array, aim_model: ActionInfluenceModel) -> void:
	fill_governors(governor_dicts, aim_model)


func fill_governors(governor_array: Array, aim_model: ActionInfluenceModel) -> void:
	_governors.clear()
	for governor_dict: Dictionary in governor_array:
		var sensor = aim_model.get_sensor(governor_dict.get("sensor"))
		_governors.append(Governor.new(governor_dict, sensor))
