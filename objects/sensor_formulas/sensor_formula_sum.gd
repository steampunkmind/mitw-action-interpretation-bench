class_name SensorFormulaSum extends SensorFormula

const TYPE = "Sum"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	var result = 0.0
	var sensor_names = formulas.get(key)
	for sensor_name: String in sensor_names:
		var other_sensor = model.get_sensor(sensor_name)
		result += other_sensor.get_value()
	return result


func get_text(text: String, key: String, formulas: Dictionary) -> String:
	return _sensor_list_text(text, key, formulas)
