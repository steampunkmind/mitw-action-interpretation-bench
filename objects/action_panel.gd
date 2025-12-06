class_name ActionPanel
extends ColorRect

var _action: Action

func init(position: Vector2, size_x: float, action: Action):
	self.position = position
	size.x = size_x
	$Total.size.x = size_x
	$Votes.size.x = size_x


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
