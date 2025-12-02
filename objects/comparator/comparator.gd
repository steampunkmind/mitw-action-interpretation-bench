extends ColorRect

@export var perception_value: float = 75
@export var perception_max: float = 100
@export var perception_min: float = 0

@export var error_threshold = 50
@export var error_peak = 25
@export var error_max = 1000

var top_margin: float = 100
var bottom_margin: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_error_threshold_line()
	set_error_peak_line()
	set_error_gradient()
	set_perception_line(calc_perception_y(perception_value))
	set_perception_value(perception_value)
	
	
func set_error_threshold_line() -> void:
	var y_value = calc_perception_y(error_threshold)
	set_line_y($ErrorThreshold, y_value, 0)
	set_line_y($ErrorThreshold, y_value, 1)
	
	
func set_error_peak_line() -> void:
	var y_value = calc_perception_y(error_peak)
	set_line_y($ErrorPeak, y_value, 0)
	set_line_y($ErrorPeak, y_value, 1)
	
	
func set_error_gradient() -> void:
	var fill_from = $ErrorColor.get_texture().get_gradient()
	fill_from.set_offset(0, calc_perception_percent(error_threshold))
	fill_from.set_offset(1, calc_perception_percent(error_peak))
	
	
func set_perception_line(value: float) -> void:
	set_line_y($PerceptionLine, value, 0)
	set_line_y($PerceptionLine, value, 1)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func set_perception_value(value: float) -> float:
	if (value > perception_max):
		value = perception_max
	elif (value < perception_min):
		value = perception_min
	
	set_perception_line(calc_perception_y(value))
	$PerceptionValue.text = str(value)
	
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
	return error_value
	
func error_value(value: float) -> float:
	return error_max * (value - error_threshold)/(error_peak - error_threshold)
	
	 
# Utils
func calc_perception_y(value: float) -> float:
	var container_y = get_size().y
	var ratio = (container_y - top_margin - bottom_margin)/(perception_max - perception_min)
	return container_y - bottom_margin - (value * ratio)
	
	
func calc_perception_percent(value: float) -> float:
	var perception_range = perception_max-perception_min
	return (perception_range - value)/perception_range
	
	
func set_line_y(line: Line2D, value: float, index: int) -> void:
	var point = line.get_point_position(index)
	point.y = value
	line.set_point_position(index, point)
