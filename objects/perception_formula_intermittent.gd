class_name PerceptionFormulaIntermittent extends PerceptionFormula

const TYPE = "Intermittent"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	var formula = formulas.get(key)
	var off_timer = formula.get("off_timer")
	if off_timer != null:
		if off_timer > 0:
			off_timer -= 1
			formula.set("off_timer", off_timer)
		else:
			formula.erase("off_timer")
			formula.set("on_timer", randi_range(formula.get("on_min_duration"), formula.get("on_max_duration")))
		return formula.get("off_value")
		
	var on_timer = formula.get("on_timer")
	if on_timer != null:
		if on_timer > 0:
			on_timer -= 1
			formula.set("on_timer", on_timer)
		else:
			formula.erase("on_timer")
			formula.set("off_timer", randi_range(formula.get("off_min_duration"), formula.get("off_max_duration")))
			formula.set("off_value", randi_range(formula.get("off_min_value"), formula.get("off_max_value")))
	else:
		formula.set("on_timer", randi_range(formula.get("on_min_duration"), formula.get("on_max_duration")))
		
	return value


func get_text(key: String, formulas: Dictionary) -> String:
	var formula = formulas.get(key)
	var off_timer = formula.get("off_timer")
	if off_timer != null:
		return str(formula.get("off_value")) + "|" + str(off_timer)
		
	var on_timer = formula.get("on_timer")
	if on_timer != null:
		return "0|" + str(on_timer)
	
	return "0"
