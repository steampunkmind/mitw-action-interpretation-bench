class_name Governor extends RefCounted

var _name: String
var _sensor: Sensor

# Constructor
func _init(name: String, sensor: Sensor):
	_name = name
	_sensor = sensor


func get_name():
	return _name


func get_sensor():
	return _sensor


func get_sensor_name() -> String:
	if _sensor: 
		return _sensor.get_name()
	return "NOT FOUND"


func get_dict() -> Dictionary:
	var result = {}
	result.set('name', _name)
	result.set('sensor', _sensor.get_name())
	return result
