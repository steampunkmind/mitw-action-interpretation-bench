class_name Governor extends RefCounted

var _dict: Dictionary
var _sensor: Sensor

# Constructor
func _init(dict: Dictionary, sensor: Sensor):
	_dict = dict
	_sensor = sensor


func get_name():
	return _dict.get('name')


# The sensor value at which this governor starts producing an error. 
# Errors always start at zero and are positive values.
func error_threshold():
	return _dict.get('error_threshold')


# The sensor value at which this governor produces its maximum error value. 
# Errors always start at zero and are positive values.
func error_peak():
	return _dict.get('error_peak')


# The maximum error value this governor will produce.
# The sensor value will be at error_peak when error_max is produced.
# Beyond this point, changes in the sensor value will not effect the error value. 
func error_max():
	return _dict.get('error_max')


func get_sensor():
	return _sensor


func get_sensor_name() -> String:
	if _sensor: 
		return _sensor.get_name()
	return "NOT FOUND"


func is_max_type() -> bool:
	return error_threshold() < error_peak()


func is_min_type() -> bool:
	return error_peak() < error_threshold()


func get_dict() -> Dictionary:
	var result = _dict.duplicate()
	result.set('sensor', _sensor.get_name())
	return result
