class_name SensorFormulaInflowPercent extends SensorFormula

const TYPE = "Inflow Percent"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	var formula = formulas.get(key)
	for formula_dict: Dictionary in formula:
		var sensor_name = formula_dict.get("sensor_name")
		var inflow_percent = formula_dict.get("inflow_percent")
		var other_sensor = model.get_sensor(sensor_name)
		var sensor_value = model.get_sensor(sensor_name).get_value()
		value = value + (sensor_value * (inflow_percent/100))
	return value


func get_text(text: String, key: String, formulas: Dictionary) -> String:
	var result = key + ": ["
	var cnt = 0
	for sensor_inflow: Dictionary in formulas.get(key):
		if (cnt > 0):
			result += ", "
		var sensor_name = sensor_inflow.get("sensor_name")
		var inflow_percent = sensor_inflow.get("inflow_percent")
		result += "{" + sensor_name + ": " + str(inflow_percent) + "}"
		cnt += 1
	result += "]"
	return text + result
