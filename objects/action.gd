class_name Action extends RefCounted

var _dict = {}
var _influences: Array[Influence]

# Constructor
func _init(name: String, visible: bool, influences: Array[Influence] = []):
	_dict.set('name', name)
	_dict.set('visible', visible)
	_influences = influences


func get_name():
	return _dict.get('name')


func get_visible():
	return _dict.get('visible')


func get_influences() -> Array[Influence]:
	return _influences


func set_influences(value: Array[Influence]) -> void:
	_influences = value


func get_dict() -> Dictionary:
	var result = _dict.duplicate(true)
	var influences = {}
	for influence: Influence in _influences:
		influences.set(influence.get_sensor_name(), influence.get_dict())
	result.set('influences', influences)
	return result
