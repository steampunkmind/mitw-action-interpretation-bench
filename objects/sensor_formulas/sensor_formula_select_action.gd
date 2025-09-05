class_name SensorFormulaSelectAction extends SensorFormula

const TYPE = "Select Action"

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	var formula = formulas.get(key)
	var delay_value = formula.get("value")
	if delay_value == null:
		delay_value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
	else:
		delay_value -= 1
	if (delay_value < 0):
		var actions = formula.get("actions")
		var i = randi() % actions.size()
		var action_name = actions[i]
		action_agent.select_action(action_name)
		delay_value = randi_range(formula.get("min_delay"), formula.get("max_delay"))
	formula.set("value", delay_value)
	formulas.set(key, formula)
	return value
