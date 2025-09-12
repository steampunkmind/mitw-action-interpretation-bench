class_name GovernorDisplayCell extends ColorRect

var _aim_model: ActionInfluenceModel
var _gam_model: GovernorActionModel
var _action: Action
var _governor: Governor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func init(aim_model: ActionInfluenceModel, gam_model: GovernorActionModel, action: Action, governor: Governor, x: float):
	_aim_model = aim_model
	_gam_model = gam_model
	_action = action
	_governor = governor
	var p = get_position()
	p.x = x
	set_position(p)
