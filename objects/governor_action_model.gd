class_name GovernorActionModel extends Object

var _governors: Array[Governor]:
	get = get_governors, set = set_governors
var _actions: Array[Action]:
	get = get_actions, set = set_actions

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
		_governors.append(Governor.new(governor_dict, sensor, aim_model))


## Actions ##
func get_actions() -> Array[Action]:
	return _actions


func set_actions(value: Array[Action]):
	_actions = value


## Utils ##
func get_absolute_evaluation_value(action: Action) -> float:
	var result = 0.0
	for governor: Governor in get_governors():
		result += abs(governor.get_action_evaluation_value(action)) # use absolute value
	return result


func get_total_votes_value(action: Action) -> float:
	var result = 0.0
	for governor: Governor in get_governors():
		if governor.get_error_value() > 0:
			result += governor.get_votes(action)
	return result


func get_lowest_evaluation_action() -> Action:
	var value = INF
	var actions = []
	for action: Action in _actions:
		if action.get_visible():
			var action_value = get_absolute_evaluation_value(action)
			if action_value < value:
				value = action_value
				actions = [action]
			elif action_value == value:
				actions.append(action)
				
	actions.shuffle()
	return actions[0]


func get_highest_votes_action() -> Action:
	var value = 0.0
	var actions = []
	for action: Action in _actions:
		if action.get_visible():
			var action_value = get_total_votes_value(action)
			if action_value > value:
				value = action_value
				actions = [action]
			elif action_value == value:
				actions.append(action)
				
	actions.shuffle()
	return actions[0]
