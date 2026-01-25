class_name GovernorDisplayCell extends ColorRect

var _aim_model: ActionInfluenceModel
var _gam_model: GovernorActionModel
var _action: Action
var _governor: Governor
var _max_progress: float
var _unity_influence: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_max_progress = size.x - ($Border.width/2) - $InfluenceLine.width
	_unity_influence = (size.y - $Border.width)/2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(time_delta: float) -> void:
	pass


func init(aim_model: ActionInfluenceModel, gam_model: GovernorActionModel, action: Action, governor: Governor, x: float, width: float):
	_aim_model = aim_model
	_action = action
	_governor = governor
	var p = get_position()
	p.x = x
	set_position(p)
	var s = get_size()
	s.x = width
	set_size(s)
	$Value.size.x = width
	$Border.points[1].x = width - 3
	$Border.points[2].x = width - 3
	$InfluenceLine.points[0].x = width - 5
	$InfluenceLine.points[1].x = width - 5


func refresh() -> void:
	if _governor.is_evaluating_action(_action):
		set_color(Color(Color.PEACH_PUFF))
		$Border.set_visible(true)
		$Value.text = _governor.get_action_evaluation_text(_action)
		$DurationLine.set_visible(true)
		$DurationLine.points[1].x = _max_progress * _governor.get_action_evaluation_progress(_action)
		$InfluenceLine.set_visible(true)
		$InfluenceLine.points[1].y = $InfluenceLine.points[0].y - _unity_influence * _governor.get_action_evaluation_influence(_action)
		
	else:
		set_color(Color(1, 1, 1, 1))
		$Border.set_visible(false)
		$DurationLine.set_visible(false)
		$InfluenceLine.set_visible(false)
