class_name Influence extends RefCounted

var _sensor_name
var _formula

# Constructor
func _init(sensor_name: String, formula: Formula):
	_sensor_name = sensor_name
	_formula = formula
	
	
func get_sensor_name():
	return _sensor_name
	
	
func get_formula():
	return _formula
	
	
func get_dict() -> Dictionary:
	return _formula.get_dict()
	
	
