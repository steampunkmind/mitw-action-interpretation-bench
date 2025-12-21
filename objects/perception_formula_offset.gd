class_name PerceptionFormulaOffset extends PerceptionFormula

const TYPE = "Offset"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value - 20
	
