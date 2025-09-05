class_name Sensor extends RefCounted

var _dict = {}
var _formulas = {}
var _types = {}

# Constructor
func _init(name: String, min: float, max: float, value: float):
	_dict.set('name', name)
	_dict.set('min', min)
	_dict.set('max', max)
	_dict.set('value', value)
	
	_types.set(SensorFormulaLinear.TYPE, SensorFormulaLinear.new())
	_types.set(SensorFormulaSum.TYPE, SensorFormulaSum.new())
	_types.set(SensorFormulaMaxLimit.TYPE, SensorFormulaMaxLimit.new())
	_types.set(SensorFormulaOutflowPercent.TYPE, SensorFormulaOutflowPercent.new())
	_types.set(SensorFormulaInflowPercent.TYPE, SensorFormulaInflowPercent.new())
	_types.set(SensorFormulaSelectAction.TYPE, SensorFormulaSelectAction.new())
	_types.set(SensorFormulaDelayAction.TYPE, SensorFormulaDelayAction.new())
	_types.set(SensorFormulaShuffleAction.TYPE, SensorFormulaShuffleAction.new())
	
	
func get_name():
	return _dict.get('name')
	
	
func get_min():
	return _dict.get('min')
	
	
func get_max():
	return _dict.get('max')
	
	
func get_value() -> float:
	return _dict.get('value')
	
	
func set_value(value: float):
	_dict.set('value', value)
	
	
func get_formulas() -> Dictionary:
	return _formulas
	
	
func set_formulas(value: Dictionary):
	_formulas = value
	
	
func get_dict() -> Dictionary:
	return _dict
	
	
### Formulas ###
func get_formula_value(sensor: Sensor, formulas: Dictionary) -> float:
	var result = sensor.get_value()
	SensorFormula.limit_value = false
	for key: String in formulas.keys():
		var formula_type_name = key.get_basename() 
		var formula_type = _types.get(formula_type_name)
		if formula_type == null:
			print(formula_type_name + " formula type not found.")
		else:
			result = formula_type.get_value(result, key, formulas)
		
	if (SensorFormula.limit_value && result > sensor.get_value()):
		return sensor.get_value()
		
	return result


func get_formula_text(sensor_formulas: Dictionary) -> String:
	var result = ""
	# should call to_string method in future SensorFormula Class
	if (sensor_formulas):
		for key: String in sensor_formulas:
			var formula_type_name = key.get_basename()
			var formula_type = _types.get(formula_type_name)
			if formula_type == null:
				print(formula_type_name + " formula type not found.")
			else:
				result = formula_type.get_text(result, key, sensor_formulas)
			result += "\r"
			
	return result
