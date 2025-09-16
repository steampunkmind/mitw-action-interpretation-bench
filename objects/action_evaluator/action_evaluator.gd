class_name ActionEvaluator extends RefCounted

var _dict: Dictionary
var _evaluation_value: float = 0
var _is_evaluating: int = 0
var _previous_value: float = 0
var _duration: int

func _init(evaluator_dict: Dictionary):
	_dict = evaluator_dict
	_duration = _dict.get("duration")


func start_evaluating() -> void:
	_is_evaluating = _duration


func is_evaluating() -> bool:
	return _is_evaluating > 0 


func update_evaluation(new_value: float, is_max_type: bool) -> void:
	if is_evaluating():
		_is_evaluating -= 1
		_evaluation_value = new_value - _previous_value 
		if is_max_type:
			_evaluation_value = 0 - _evaluation_value # invert value
	
	_previous_value = new_value


func get_evaluation_value() -> float:
	return _evaluation_value


func get_evaluation_text() -> String:
	return str("%.1f" % (_evaluation_value*100))
