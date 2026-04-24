class_name ActionPanel
extends ColorRect

var _action: Action

func init(position: Vector2, size_x: float, action: Action):
	self.position = position
	size.x = size_x
	$Total.size.x = size_x
	$Votes.size.x = size_x
	$BestLine.points[1].x = size_x - 2
	$BestLine.points[2].x = size_x - 2
	$LearningLine.points[1].x = size_x - 2
	$LearningLine.points[2].x = size_x - 2
	_action = action


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func refresh() -> void:
	$Total.text = str("%.1f" % (MITW.gam_model().get_absolute_evaluation_value(_action)))
	$Votes.text = str("%.1f" % (MITW.gam_model().get_total_votes_value(_action)))


func set_best_line_visible(visible: bool) -> void:
	$LearningLine.visible = false
	$BestLine.visible = visible


func set_learning_line_visible(visible: bool) -> void:
	$BestLine.visible = false
	$LearningLine.visible = visible
