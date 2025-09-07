class_name Formula extends RefCounted

var _dict

# Constructor
func _init(expressions: Dictionary):
	_dict = expressions.duplicate(true)


func get_expressions() -> Dictionary:
	return _dict


func get_dict() -> Dictionary:
	return _dict
