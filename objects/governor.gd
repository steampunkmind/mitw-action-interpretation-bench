class_name Governor extends RefCounted

var _dict: Dictionary
var _sensor: Sensor
var _action_evaluators: Dictionary

# Constructor
func _init(dict: Dictionary, sensor: Sensor, aim_model: ActionInfluenceModel):
	_dict = dict
	_sensor = sensor
	var evaluator = _dict.get("evaluator")
	for action: Action in aim_model.get_actions():
		if action.get_visible():
			_action_evaluators.set(action, ActionEvaluator.new(evaluator))


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
	var evaluator = _action_evaluators.get(action)
	evaluator.start_evaluating()


func is_evaluating_action(action: Action) -> bool:
	var evaluator = _action_evaluators.get(action)
	return evaluator.is_evaluating()


### Action Evaluating ###
func update_action_evaluations() -> void:
	var sensor_value = get_sensor().get_value()
	for action_evaluator: ActionEvaluator in _action_evaluators.values():
		action_evaluator.update_evaluation(sensor_value, is_max_type())


func get_action_evaluation_value(action: Action) -> float:
	return _action_evaluators.get(action).get_evaluation_value()


func get_action_evaluation_text(action: Action) -> String:
	return _action_evaluators.get(action).get_evaluation_text()
