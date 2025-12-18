class_name ActionDisplay
extends ColorRect

signal action_button_pressed

@export var action_array: Array[Dictionary]
@export var action_button_template: Button
@export var action_panel_template: PackedScene

var _aim_model: ActionInfluenceModel
var _gam_model: GovernorActionModel
var new_hidden_button_location_x
var new_visible_button_location_x
var action_buttons: Array[Button]
var action_panels: Array[ActionPanel]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ActionButtonTemplate.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_models(aim_model: ActionInfluenceModel,  gam_model: GovernorActionModel):
	_aim_model = aim_model
	_gam_model = gam_model


func update_buttons():
	clear_action_buttons()
	add_action_buttons()
	show_hide_buttons()


func _action_button_pressed(action: Action) -> void:
	action_button_pressed.emit(action)


func set_new_model() -> void:
	_aim_model.fill_actions(action_array)
	update_buttons()


func init_action() -> void:
	# called by bench to init after other scenes are set up. 
	_action_button_pressed(_aim_model.get_actions()[0])


func clear_action_buttons():
	for action_button: Button in action_buttons:
		remove_child(action_button)
	action_buttons.clear()
	for action_panel: ActionPanel in action_panels:
		remove_child(action_panel)
	action_panels.clear()


func add_action_buttons():
	new_hidden_button_location_x = $ActionButtonTemplate.position.x
	new_visible_button_location_x = $ActionButtonTemplate.position.x + 1740
	for action: Action in _aim_model.get_actions():
		add_action_button(action)


func add_action_button(action: Action) -> void:
	var button = $ActionButtonTemplate.duplicate(1)
	var button_margin = button.position.x
	button.name = action.get_name() + "_button"
	button.text = action.get_name()
	button.pressed.connect(_action_button_pressed.bind(action))
	add_child(button)
	action_buttons.append(button)
	button.visible = true
	
	if action.get_visible():
		button.offset_left = new_visible_button_location_x
		button.offset_top = button.position.y + (button.size.y * button.get_scale().y) + button_margin
		var panel = action_panel_template.instantiate()
		var panel_position = Vector2(new_visible_button_location_x, button.position.y + (button.size.y * button.get_scale().y))
		panel.init(panel_position, (button.size.x * button.get_scale().x), _gam_model, action)
		panel.name = action.get_name() + "_panel"
		add_child(panel)
		action_panels.append(panel)
		new_visible_button_location_x = button.position.x + (button.size.x * button.get_scale().x) + button_margin
		action.set_name_width(button.size.x * button.get_scale().x)
	else:
		button.offset_left = new_hidden_button_location_x
		new_hidden_button_location_x = button.position.x + (button.size.x * button.get_scale().x) + button_margin


func show_hide_buttons():
	for action: Action in _aim_model.get_actions():
		if !action.get_visible():
			var button = find_child(action.get_name() + "_button", false, false)
			var panel = find_child(action.get_name() + "_panel", false, false)
			if _aim_model.get_edit_mode():
				button.show()
				if panel:
					panel.show()
			else:
				button.hide()
				if panel:
					panel.hide()


func refresh() -> void:
	for action_panel: ActionPanel in action_panels:
		action_panel.refresh()


func best_action_selected(selected_action: Action) -> void:
	for action: Action in _aim_model.get_actions():
		if action.get_visible():
			var panel = find_child(action.get_name() + "_panel", false, false)
			panel.set_best_line_visible(action == selected_action)


func learning_action_selected(selected_action: Action) -> void:
	for action: Action in _aim_model.get_actions():
		if action.get_visible():
			var panel = find_child(action.get_name() + "_panel", false, false)
			panel.set_learning_line_visible(action == selected_action)


### Action Agent functions ###
func select_action(action_name: String) -> void:
	for action: Action in _aim_model.get_actions():
		if (action.get_name() == action_name):
			action_button_pressed.emit(action)
			break


func shuffle_action(action_names) -> void:
	var actions_to_shuffle = []
	for action: Action in _aim_model.get_actions():
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
