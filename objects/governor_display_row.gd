class_name GovernorDisplayRow extends ColorRect

var _gam_model: GovernorActionModel
var _governor: Governor 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_gam_model(value: GovernorActionModel):
	_gam_model = value


func set_row_location(y: float) -> void:
	var p = get_position()
	p.y = y
	set_position(p)


func set_governor(governor: Governor) -> void:
	_governor = governor
	set_name(governor.get_name()) # sets name of node
	$Name.text = governor.get_name()
