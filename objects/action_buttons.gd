class_name ActionButtons
extends ColorRect

signal action_button_pressed

@export var action_array: Array[Dictionary]
@export var action_button_template: Button

var _model: ActionInfluenceModel
var new_button_location
var action_buttons: Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionButtonTemplate.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_model(value: ActionInfluenceModel):
	_model = value


func update_buttons():
	clear_action_buttons()
	add_action_buttons()
	show_hide_buttons()


func _action_button_pressed(action: Action) -> void:
	action_button_pressed.emit(action)


func set_new_model() -> void:
	_model.fill_actions(action_array)
	update_buttons()


func init_action() -> void:
	# called by bench to init after other scenes are set up. 
	_action_button_pressed(_model.get_actions()[0])


func clear_action_buttons():
	for action_button: Button in action_buttons:
		remove_child(action_button)
	action_buttons.clear()


func add_action_buttons():
	new_button_location = $ActionButtonTemplate.position.x
	for action: Action in _model.get_actions():
		add_action_button(action)


func add_action_button(action: Action) -> void:
	var button = $ActionButtonTemplate.duplicate(1)
	var button_margin = button.position.x
	button.name = action.get_name()
	button.text = action.get_name()
	button.offset_left = new_button_location
	button.pressed.connect(_action_button_pressed.bind(action))
	add_child(button)
	action_buttons.append(button)
	button.visible = true
	new_button_location = button.position.x + (button.size.x * button.get_scale().x) + button_margin


func show_hide_buttons():
	for action: Action in _model.get_actions():
		if !action.get_visible():
			var child = find_child(action.get_name(), false, false)
			if _model.get_edit_mode():
				child.show()
			else:
				child.hide()


### Action Agent functions ###
func select_action(action_name: String) -> void:
	for action: Action in _model.get_actions():
		if (action.get_name() == action_name):
			action_button_pressed.emit(action)
			break


func shuffle_action(action_names) -> void:
	var actions_to_shuffle = []
	for action: Action in _model.get_actions():
		if action_names.has(action.get_name()):
			actions_to_shuffle.append(action)
	
	var influences_array = []
	for action: Action in actions_to_shuffle:
		var influences = action.get_influences()
		influences_array.append(influences)
		
	influences_array.shuffle()
	
	var influences_index = 0
	for action: Action in actions_to_shuffle:
		var influences = influences_array[influences_index]
		action.set_influences(influences)
		influences_index = influences_index + 1
