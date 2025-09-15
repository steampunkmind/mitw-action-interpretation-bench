class_name GovernorDisplayCell extends ColorRect

var _aim_model: ActionInfluenceModel
var _gam_model: GovernorActionModel
var _action: Action
var _governor: Governor
var _time_total: float = 0
var _delta_value: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(time_delta: float) -> void:
	_time_total += time_delta
	if _governor.is_evaluating_action(_action):
		set_color(Color(Color.PEACH_PUFF))
		if _time_total > 1:
			var new_value = _governor.get_sensor().get_value()
			var change_value = new_value - _delta_value 
			_delta_value = new_value
			if _governor.is_max_type():
				change_value = 0 - change_value # invert value
			$Value.text = str("%.1f" % change_value)
			_time_total = 0
	else:
		set_color(Color(1, 1, 1, 1))


func init(aim_model: ActionInfluenceModel, gam_model: GovernorActionModel, action: Action, governor: Governor, x: float):
	_aim_model = aim_model
	_gam_model = gam_model
	_action = action
	_governor = governor
	_delta_value = _governor.get_sensor().get_value()
	var p = get_position()
	p.x = x
	set_position(p)
