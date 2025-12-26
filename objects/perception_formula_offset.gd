class_name PerceptionFormulaOffset extends PerceptionFormula

const TYPE = "Offset"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value + formulas.get(key)


func get_text(key: String, formulas: Dictionary) -> String:
	return str("%.1f" % formulas.get(key))
