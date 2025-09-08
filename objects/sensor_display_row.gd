class_name SensorDisplayRow extends ColorRect

var _aim_model: ActionInfluenceModel
var _sensor: Sensor 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_aim_model(value: ActionInfluenceModel):
	_aim_model = value


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)


func set_sensor(sensor: Sensor) -> void:
	_sensor = sensor
	set_name(sensor.get_name()) # sets name of node
	$Name.text = sensor.get_name()


func set_sensor_value(value: float) -> void:
	_sensor.set_value(value)
	$SensorValue.text = str("%.1f" % value)


func update_sensor_value() -> void:
	if (_sensor.get_formulas() != null):
		var new_sensor_value = _sensor.get_formula_value(_sensor, _sensor.get_formulas())
		if (new_sensor_value < _sensor.get_min()):
			new_sensor_value = _sensor.get_min()
		elif (new_sensor_value > _sensor.get_max()):
			new_sensor_value = _sensor.get_max()
		set_sensor_value(new_sensor_value)


func set_formula(formula: Formula, edit_mode: bool) -> void:
	var expressions = formula.get_expressions()
	for key: String in expressions:
		_sensor.get_formulas().set(key, expressions.get(key))
