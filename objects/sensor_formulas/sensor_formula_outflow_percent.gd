class_name SensorFormulaOutflowPercent extends SensorFormula

const TYPE = "Outflow Percent"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value - (value * (formulas.get(key)/100))
