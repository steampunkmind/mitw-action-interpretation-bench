class_name SensorFormula extends RefCounted

static var action_agent
static var model
static var limit_value

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value + formulas.get(key)


func get_text(text: String, key: String, formulas: Dictionary) -> String:
	return text + key + ": " + str(formulas.get(key))


func _sensor_list_text(text: String, key: String, formulas: Dictionary) -> String:
	var result = key + ": ["
	var cnt = 0
	for sensor_name: String in formulas.get(key):
		if (cnt > 0):
			result += ", "
		result += sensor_name
		cnt += 1
	result += "]"
	return text + result
