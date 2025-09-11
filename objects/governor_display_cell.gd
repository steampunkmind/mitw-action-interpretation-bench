class_name GovernorDisplayCell extends ColorRect

var _aim_model: ActionInfluenceModel
var _gam_model: GovernorActionModel
var _action

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_models(aim_model: ActionInfluenceModel, gam_model: GovernorActionModel):
	_aim_model = aim_model
	_gam_model = gam_model


func set_action(action: Action) -> void:
	_action = action


func set_cell_location(x: float) -> void:
	var p = get_position()
	p.x = x
	set_position(p)
