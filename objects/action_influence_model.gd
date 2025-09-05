class_name ActionInfluenceModel extends Object

var _actions: Array[Action]:
	get = get_actions, set = set_actions
var _sensors = {}
var _edit_mode: bool = false:
	get = get_edit_mode, set = set_edit_mode

var _sensor_dict = {}

## Actions ##
func get_actions() -> Array[Action]:
	return _actions


func set_actions(value: Array[Action]):
	_actions = value


func get_action_dicts() -> Array:
	var result = []
	for action: Action in _actions:
		result.append(action.get_dict())	
	return result


func set_action_dicts(action_dicts: Array) -> void:
	fill_actions(action_dicts)


func fill_actions(action_array: Array) -> void:
	_actions.clear()
	for action_dict: Dictionary in action_array:
		var influences: Array[Influence]
		var influence_dict = action_dict.get("influences")
		for sensor_name: String in influence_dict:
			var expressions = influence_dict.get(sensor_name)
			var formula = Formula.new(expressions)
			var influence = Influence.new(sensor_name, formula)
			influences.append(influence)
		
		_actions.append(Action.new(action_dict.get("name"), action_dict.get("visible"), influences))


## Sensors ##
func get_sensors() -> Array:
	return _sensors.values()


func set_sensors(value: Array[Sensor]):
	_sensors.clear()
	for sensor: Sensor in value:
		_sensors.set(sensor.get_name(), sensor)
	


func get_sensor(name: String) -> Sensor:
	return _sensors.get(name)


func get_sensor_dicts() -> Array:
	var sensor_dicts = []
	for sensor: Sensor in _sensors.values():
		sensor_dicts.append(sensor.get_dict())	
	return sensor_dicts


func set_sensor_dicts(sensor_dicts: Array) -> void:
	fill_sensors(sensor_dicts)


func fill_sensors(sensor_dicts: Array) -> void:
	_sensors = {}
	for sensor_dict: Dictionary in sensor_dicts:
		var name = sensor_dict.get('name')
		var min = sensor_dict.get('min')
		var max = sensor_dict.get('max')
		var value = sensor_dict.get('value')
		_sensors.set(name, Sensor.new(name, min, max, value))


func new_sensor() -> void:
	var name = "Sensor " + str(_sensors.size()+1)
	_sensors.set(name, Sensor.new(name, 0, 100, 50))


## Edit Mode ##
func get_edit_mode() -> bool:
	return _edit_mode


func set_edit_mode(value: bool) -> void:
	_edit_mode = value
