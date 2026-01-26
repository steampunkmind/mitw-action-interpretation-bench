extends ColorRect

var _governor: Governor
var top_margin: float = 100
var bottom_margin: float = 100

func init(governor) -> void:
	_governor = governor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_error_threshold_line()
	set_error_peak_line()
	set_error_gradient()
	set_percept_line(calc_percept_y(_governor.get_sensor().get_value()))
	set_percept_value(_governor.get_sensor().get_value())
	
	
func set_error_threshold_line() -> void:
	var y_value = calc_percept_y(_governor.error_threshold())
	set_line_y($ErrorThreshold, y_value, 0)
	set_line_y($ErrorThreshold, y_value, 1)
	
	
func set_error_peak_line() -> void:
	var y_value = calc_percept_y(_governor.error_peak())
	set_line_y($ErrorPeak, y_value, 0)
	set_line_y($ErrorPeak, y_value, 1)
	
	
func set_error_gradient() -> void:
	var fill_from = $ErrorColor.get_texture().get_gradient()
	fill_from.set_offset(0, _governor.error_threshold_percent())
	fill_from.set_offset(1, _governor.error_peak_percent())
	
	
func set_percept_line(value: float) -> void:
	set_line_y($PerceptLine, value, 0)
	set_line_y($PerceptLine, value, 1)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func refresh() -> void:
	set_percept_value(_governor.get_percept_value())
	
	
func set_percept_value(value: float) -> void:
	if (value > _governor.get_sensor().get_max()):
		value = _governor.get_sensor().get_max()
	elif (value < _governor.get_sensor().get_min()):
		value = _governor.get_sensor().get_min()
	
	set_percept_line(calc_percept_y(value))
	$PerceptValue.text = str("%.1f" % value)
	
	var error_value = 0
	if (_governor.error_threshold() >= _governor.error_peak()):
		if (value < _governor.error_peak()): 
			error_value = _governor.error_max()
		elif (value < _governor.error_threshold()):
			error_value = error_value(value)
	else:
		if (_governor.error_peak() < value): 
			error_value = _governor.error_max()
		elif (_governor.error_threshold() < value):
			error_value = error_value(value)
		
	$ErrorValue.text = str("%.1f" % error_value)
	_governor.set_error_value(error_value)
	
	
func error_value(value: float) -> float:
	return _governor.error_max() * (value - _governor.error_threshold())/(_governor.error_peak() - _governor.error_threshold())
	
	 
# Utils
func calc_percept_y(value: float) -> float:
	var container_y = get_size().y
	var ratio = (container_y - top_margin - bottom_margin)/(_governor.get_sensor().get_range())
	return container_y - bottom_margin - (value * ratio) + (_governor.get_sensor().get_min() * ratio)
	
	
func set_line_y(line: Line2D, value: float, index: int) -> void:
	var point = line.get_point_position(index)
	point.y = value
	line.set_point_position(index, point)
