class_name ActionEvaluator extends RefCounted

var _dict: Dictionary
var _evaluation_value: float = 0
var _duration: int = 0
var _progress: int = 0
var _previous_value: float = 0
var _retain: int = 0
var _influences_index: int
var _influence_progress: int
var _evaluation_frames: Array[float]

func _init(evaluator_dict: Dictionary):
	_dict = evaluator_dict
	_duration = _dict.get("duration")
	_progress = _duration
	_retain = _dict.get("retain")


func start_evaluating() -> void:
	_progress = -1
	_influences_index = 0
	_influence_progress = -1


func is_evaluating() -> bool:
	return _progress < _duration


func update_evaluation(new_value: float, is_max_type: bool) -> void:
	_progress += 1
	_influence_progress += 1
	if is_evaluating():
		var frame_value = new_value - _previous_value 
		frame_value *= _frame_influence()
		if is_max_type:
			frame_value = 0 - frame_value # invert value
			
		_evaluation_frames.append(frame_value)
		if (_evaluation_frames.size() > (_duration + _retain)):
			_evaluation_frames.remove_at(0)
			
		var sum_value = 0.0
		for value in _evaluation_frames:
			sum_value += value
			
		_evaluation_value = sum_value/_evaluation_frames.size()
		
	_previous_value = new_value


func _influence():
	# influence is optional. If it is not in the dictionary, return null
	var result = null
	var influences = _dict.get("influences")
	if influences != null:
		if _influences_index < influences.size():
			result = influences[_influences_index]
			
			# if progress is beyond influence section, go to next section
			if _influence_progress >= result.get("duration"):
				_influence_progress = 0
				_influences_index += 1
				if _influences_index < influences.size():
					result = influences[_influences_index] 
				else:
					result = null # no more influence entries
					
	return result


func _frame_influence() -> float:
	# influence is optional. If it is not in the dictionary, return 1
	var result = 1.0
	var influence = _influence()
	if influence != null:
		var duration = influence.get("duration")
		var start = influence.get("start")
		var end = influence.get("end")
		result =  (start + (((end - start) / (duration - 1)) * _influence_progress)) / 100
		
	return result


func get_evaluation_value() -> float:
	return _evaluation_value


func get_evaluation_text() -> String:
	return str("%.1f" % (_evaluation_value*100))


func get_evaluation_progress() -> float:
	return _progress as float/_duration


func get_evaluation_influence() -> float:
	return _frame_influence() # 100 #_influence
