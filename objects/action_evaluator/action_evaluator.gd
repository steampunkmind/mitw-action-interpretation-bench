class_name ActionEvaluator extends RefCounted

var _evaluation_value = 0

func update_evaluation(previous_value: float, new_value: float, is_max_type: bool) -> void:
	_evaluation_value = new_value - previous_value 
	if is_max_type:
		_evaluation_value = 0 - _evaluation_value # invert value


func get_evaluation_value() -> float:
	return _evaluation_value


func get_evaluation_text() -> String:
	return str("%.1f" % (_evaluation_value*100))
