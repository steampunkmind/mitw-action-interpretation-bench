class_name ActionPanel
extends ColorRect

var _gam_model: GovernorActionModel
var _action: Action

func init(position: Vector2, size_x: float, gam_model: GovernorActionModel, action: Action):
	self.position = position
	size.x = size_x
	$Total.size.x = size_x
	$Votes.size.x = size_x
	_gam_model = gam_model
	_action = action


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func refresh() -> void:
	var value = 0.0
	for governor: Governor in _gam_model.get_governors():
		value += governor.get_action_evaluation_value(_action)
		
	$Total.text = str("%.1f" % (value*100))
