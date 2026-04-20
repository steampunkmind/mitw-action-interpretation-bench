class_name SensorDisplay extends ColorRect

@export var sensor_display_row_template: PackedScene

var sensor_display_rows: Dictionary[String, SensorDisplayRow]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_sensors() -> void:
	clear_sensor_display_rows()
	add_sensor_display_rows()


func clear_sensor_display_rows() -> void:
	for sensor_row: SensorDisplayRow in sensor_display_rows.values():
		remove_child(sensor_row)
	
	sensor_display_rows.clear()


func add_sensor_display_rows() -> void:
	var header_margin = 58
	var row_margin = 10
	var row_location = header_margin
	for sensor: Sensor in MITW.aim_model().get_sensors():
		var row = sensor_display_row_template.instantiate()
		row.set_sensor(sensor)
		row.set_row_location(row_location)
		row.set_aim_model(MITW.aim_model())
		add_child(row)
		sensor_display_rows.set(sensor.get_name(), row)
		row_location = row_location + 58


func update_sensor_values() -> void:
	for row in sensor_display_rows.values():
		row.update_sensor_value()
