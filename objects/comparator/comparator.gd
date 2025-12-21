extends ColorRect

@export var percept_value: float = 75
@export var percept_max: float = 100
@export var percept_min: float = 0

@export var error_threshold = 50
@export var error_peak = 25
@export var error_max = 1000

var _governor: Governor
var top_margin: float = 100
var bottom_margin: float = 100

func init(governor) -> void:
	_governor = governor
	var sensor = governor.get_sensor()
	percept_value = sensor.get_value()
	percept_max = sensor.get_max()
	percept_min = sensor.get_min()
	
	error_threshold = governor.error_threshold()
	error_peak = governor.error_peak()
	error_max = governor.error_max()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_error_threshold_line()
	set_error_peak_line()
	set_error_gradient()
	set_percept_line(calc_percept_y(percept_value))
	set_percept_value(percept_value)
	
	
func set_error_threshold_line() -> void:
	var y_value = calc_percept_y(error_threshold)
	set_line_y($ErrorThreshold, y_value, 0)
	set_line_y($ErrorThreshold, y_value, 1)
	
	
func set_error_peak_line() -> void:
	var y_value = calc_percept_y(error_peak)
	set_line_y($ErrorPeak, y_value, 0)
	set_line_y($ErrorPeak, y_value, 1)
	
	
func set_error_gradient() -> void:
	var fill_from = $ErrorColor.get_texture().get_gradient()
	fill_from.set_offset(0, calc_percept_percent(error_threshold))
	fill_from.set_offset(1, calc_percept_percent(error_peak))
	
	
func set_percept_line(value: float) -> void:
	set_line_y($PerceptLine, value, 0)
	set_line_y($PerceptLine, value, 1)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func set_percept_value(value: float) -> void:
	if (value > percept_max):
		value = percept_max
	elif (value < percept_min):
		value = percept_min
	
	set_percept_line(calc_percept_y(value))
	$PerceptValue.text = str("%.1f" % value)
	
	var error_value = 0
	if (error_threshold >= error_peak):
		if (value < error_peak): 
			error_value = error_max
		elif (value < error_threshold):
			error_value = error_value(value)
	else:
		if (error_peak < value): 
			error_value = error_max
		elif (error_threshold < value):
			error_value = error_value(value)
		
	$ErrorValue.text = str("%.1f" % error_value)
	_governor.set_error_value(error_value)
	
	
func error_value(value: float) -> float:
	return error_max * (value - error_threshold)/(error_peak - error_threshold)
	
	 
# Utils
func calc_percept_y(value: float) -> float:
	var container_y = get_size().y
	var ratio = (container_y - top_margin - bottom_margin)/(percept_max - percept_min)
	return container_y - bottom_margin - (value * ratio) + (percept_min * ratio)
	
	
func calc_percept_percent(value: float) -> float:
	var percept_range = percept_max-percept_min
	return (percept_range - (value - percept_min))/percept_range
	
	
func set_line_y(line: Line2D, value: float, index: int) -> void:
	var point = line.get_point_position(index)
	point.y = value
	line.set_point_position(index, point)
