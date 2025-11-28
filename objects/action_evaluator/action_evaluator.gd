class_name ActionEvaluator extends RefCounted

var _dict: Dictionary
var _evaluation_value: float = 0
var _duration: int = 0
var _progress: int = 0
var _previous_value: float = 0
var _retain: int = 0
var _slope_percent: float = 0
var _evaluation_frames: Array[float]

func _init(evaluator_dict: Dictionary):
	_dict = evaluator_dict
	_duration = _dict.get("duration")
	_progress = _duration
	_retain = _dict.get("retain")
	_slope_percent = _dict.get("slope_percent")/100


func start_evaluating() -> void:
	_progress = 0


func is_evaluating() -> bool:
	return _progress < _duration


func update_evaluation(new_value: float, is_max_type: bool) -> void:
	if is_evaluating():
		_progress += 1
		var frame_value = new_value - _previous_value 
		if is_max_type:
			frame_value = 0 - frame_value # invert value
	
		_evaluation_frames.append(frame_value)
		if (_evaluation_frames.size() > (_duration + _retain)):
			_evaluation_frames.remove_at(0)
		var slope = 0.0 - (_slope_percent/2)
		var slope_delta = _slope_percent/_evaluation_frames.size()
		var sum_value = 0.0 
		for value in _evaluation_frames:
			slope += slope_delta
			sum_value += value + (value*slope)
			
		_evaluation_value = sum_value/_evaluation_frames.size()
		
	_previous_value = new_value


func get_evaluation_value() -> float:
	return _evaluation_value


func get_evaluation_text() -> String:
	return str("%.1f" % (_evaluation_value*100))


func get_evaluation_progress() -> float:
	return _progress as float/_duration
