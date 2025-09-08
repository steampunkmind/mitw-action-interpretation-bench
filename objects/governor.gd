class_name Governor extends RefCounted

var _dict = {}

# Constructor
func _init(name: String, sensor: String):
	_dict.set('name', name)
	_dict.set('sensor', sensor)


func get_name():
	return _dict.get('name')


func get_sensor():
	return _dict.get('sensor')


func get_dict() -> Dictionary:
	var result = _dict.duplicate(true)
	return result
