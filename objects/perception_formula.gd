class_name PerceptionFormula extends RefCounted

var _is_complete: bool = false

func get_value(value: float, key: String, formulas: Dictionary) -> float:
	return value


func set_complete(is_complete: bool) -> void:
	_is_complete = is_complete


func is_complete() -> bool:
	return _is_complete
