class_name SensorFormulaMaxLimit extends SensorFormula

const TYPE = "Max Limit"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	var sensor_names = formulas.get(key)
	for sensor_name: String in sensor_names:
		var other_sensor = model.get_sensor(sensor_name)
		if (other_sensor.get_value() >= other_sensor.get_max()):
			limit_value = true
			break
	return value


func get_text(text: String, key: String, formulas: Dictionary) -> String:
	return _sensor_list_text(text, key, formulas)
