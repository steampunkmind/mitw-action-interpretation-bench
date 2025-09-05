class_name SensorFormulaDelayAction extends SensorFormula

const TYPE = "Delay Action"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	var formula = formulas.get(key)
	var delay_value = formula.get("value")
	if delay_value == null:
		delay_value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
	else:
		delay_value -= 1
	if (delay_value < 0):
		var action = formula.get("action")
		action_agent.select_action(action)
		formula.erase("value")
		formulas.set(key, formula)
		formulas.erase(key)
	else:
		formula.set("value", delay_value)
		formulas.set(key, formula)
	return value
