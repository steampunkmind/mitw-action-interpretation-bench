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


func init (aim_model: ActionInfluenceModel, gam_model: GovernorActionModel, governor: Governor, y: float):
	_aim_model = aim_model
	_gam_model = gam_model
	_governor = governor
	set_name(governor.get_name()) # sets name of node
	$Name.text = "(" + governor.get_sensor_name() + ") " + governor.get_name()
	var p = get_position()
	p.y = y
	set_position(p)
	set_actions(_aim_model.get_actions())
	$Comparator.init(governor)


func set_actions(value: Array[Action]):
	_actions = value
	var x = $Name.size.x + 41 + $Comparator.size.y # Uses y because Comparator is rotated 270° 
	for action: Action in _actions:
		if action.get_visible():
			var cell = governor_display_cell_template.instantiate()
			cell.init(_aim_model, _gam_model, action, _governor, x, action.get_name_width())
			add_child(cell)
			governor_display_cells.set(action.get_name(), cell)
			x += (action.get_name_width()) + 8


func refresh() -> void:
	$Comparator.set_perception_value(_governor.get_sensor().get_value())
	for governor_display_cell: GovernorDisplayCell in governor_display_cells.values():
		governor_display_cell.refresh()
