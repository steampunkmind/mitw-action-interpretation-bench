class_name PerceptionFormula extends RefCounted

var _is_complete: bool = false

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value


func get_text(key: String, formulas: Dictionary) -> String:
	return ""


func init_expression(expression) -> void:
	pass # Override to init expression before adding to sensor.


func increment_frame(key: String, formulas: Dictionary) -> void:
	pass # Override to track frames and set is_complete if appropriate.


func set_complete(is_complete: bool) -> void:
	_is_complete = is_complete


func is_complete() -> bool:
	return _is_complete
