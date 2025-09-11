class_name GovernorDisplayRow extends ColorRect

@export var governor_display_cell_template: PackedScene

var _aim_model: ActionInfluenceModel
var _gam_model: GovernorActionModel
var _governor: Governor 
var _actions = []
var governor_display_cells: Dictionary[String, GovernorDisplayCell]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_models(aim_model: ActionInfluenceModel, gam_model: GovernorActionModel):
	_aim_model = aim_model
	_gam_model = gam_model
	set_actions(_aim_model.get_actions())


func set_actions(value: Array[Action]):
	_actions = value
	var x = 400
	for action: Action in _actions:
		if action.get_visible():
			var cell = governor_display_cell_template.instantiate()
			cell.set_models(_aim_model, _gam_model)
			cell.set_cell_location(x)
			cell.set_action(action)
			add_child(cell)
			governor_display_cells.set(action.get_name(), cell)
			x += 78


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)


func set_governor(governor: Governor) -> void:
	_governor = governor
	set_name(governor.get_name()) # sets name of node
	$Name.text = governor.get_name()
