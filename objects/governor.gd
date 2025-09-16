class_name Governor extends RefCounted

var _dict: Dictionary
var _sensor: Sensor
var _action_evaluators: Dictionary
var _current_action: Action
var _previous_sensor_value: float = 0

# Constructor
func _init(dict: Dictionary, sensor: Sensor, aim_model: ActionInfluenceModel):
	_dict = dict
	_sensor = sensor
	for action: Action in aim_model.get_actions():
		_action_evaluators.set(action, ActionEvaluator.new())


func get_name():
	return _dict.get('name')


# The sensor value at which this governor starts producing an error. 
# Errors always start at zero and are positive values.
func error_threshold():
	return _dict.get('error_threshold')


# The sensor value at which this governor produces its maximum error value. 
# Errors always start at zero and are positive values.
func error_peak():
	return _dict.get('error_peak')


# The maximum error value this governor will produce.
# The sensor value will be at error_peak when error_max is produced.
# Beyond this point, changes in the sensor value will not effect the error value. 
func error_max():
	return _dict.get('error_max')


func get_sensor():
	return _sensor


func get_sensor_name() -> String:
	if _sensor: 
		return _sensor.get_name()
	return "NOT FOUND"


func is_max_type() -> bool:
	return error_threshold() < error_peak()


func is_min_type() -> bool:
	return error_peak() < error_threshold()


func get_dict() -> Dictionary:
	var result = _dict.duplicate()
	result.set('sensor', _sensor.get_name())
	return result


### Action Opinions ###
func set_action(action: Action) -> void:
	_current_action = action


func get_current_action() -> Action:
	return _current_action;


func is_evaluating_action(action: Action) -> bool:
	return get_current_action() == action


### Action Evaluating ###
func update_action_evaluation(action: Action) -> void:
	var sensor_value = get_sensor().get_value()
	_action_evaluators.get(action).update_evaluation(_previous_sensor_value, sensor_value, is_max_type())
	_previous_sensor_value = sensor_value

func get_action_evaluation_value(action: Action) -> float:
	return _action_evaluators.get(action).get_evaluation_value()


func get_action_evaluation_text(action: Action) -> String:
	return _action_evaluators.get(action).get_evaluation_text()
