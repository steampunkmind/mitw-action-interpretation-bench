extends ColorRect

const DONT_SAVE = "Don't Save"

var _model: ActionInfluenceModel
var _is_model: bool = false
var _model_path: String = ""
var _is_dirty: bool = false
var _close_after_save: bool = false

@export var frame_rate: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FrameRateSlider.value = frame_rate
	$FrameRateValue.text = str(frame_rate)
	$CloseConfirmationDialog.add_button(DONT_SAVE, false, DONT_SAVE)
	_set_is_model(false)
	_set_is_dirty(false)
	$OpenFileDialog.set_current_dir("models")
	$SaveFileDialog.set_current_dir("models")
	_model = ActionInfluenceModel.new()
	SensorFormula.model = _model # set global var
	SensorFormula.action_agent = $ActionButtons # set global var
	$ActionButtons.set_model(_model)
	#$SensorGraph.set_model(_model)
	$Timer.paused = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_frame_rate_slider_value_changed(new_value: float) -> void:
	if (new_value == 0):
		$FrameRateValue.text = "PAUSED"
		$Timer.paused = true
	else:
		$FrameRateValue.text = str(new_value)
		$Timer.paused = false
	
	$Timer.set_wait_time(1/new_value)
	frame_rate = new_value
	
	
func _on_timer_timeout() -> void:
	print("bench._on_timer_timeout")
	#$SensorGraph.add_frame_to_graph()
	
	
func _on_action_button_pressed(action: Action) -> void:
	print("bench._on_action_button_pressed: " + action.get_name())
	#$SensorGraph.set_action(action)
	
	
## File Functions ##
func _on_new_button_pressed() -> void:
	$ActionButtons.set_new_model()
	#$SensorGraph.set_new_model()
	$ActionButtons.init_action()
	
func _on_open_button_pressed() -> void:
	$OpenFileDialog.popup()
	
	
func _on_open_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	_model.set_action_dicts(json.get('actions') as Array)
	_model.set_sensor_dicts(json.get('sensors') as Array)
	$ActionButtons.update_buttons()
	#$SensorGraph.update_sensors()
	$ActionButtons.init_action()
	_set_is_model(true, path)
	
	
func _on_close_button_pressed() -> void:
	if _is_dirty:
		$CloseConfirmationDialog.popup()
	else:
		_set_is_dirty(false)
		_set_is_model(false)
	
	
func _on_close_confirmation_dialog_confirmed() -> void:
	_close_after_save = true
	if (!_get_is_model_file()):
		$SaveFileDialog.popup()
	else:
		_write_file()
	
	
func _on_close_confirmation_dialog_custom_action(action: StringName) -> void:
	if action == DONT_SAVE:
		_set_is_dirty(false)
		_set_is_model(false)
	else:
		print("Unknown save confirmation dialog custom action.")
		
	$CloseConfirmationDialog.hide()
	
	
func _on_save_button_pressed() -> void:
	_close_after_save = false
	if (!_get_is_model_file()):
		$SaveFileDialog.popup()
	else:
		_write_file()
	
	
func _on_save_as_button_pressed() -> void:
	_close_after_save = false
	$SaveFileDialog.popup()
	
	
func _on_save_file_dialog_file_selected(path: String) -> void:
	_set_is_model(true, path)
	_write_file()
	
	
func _write_file() -> void:
	var file = FileAccess.open(_model_path, FileAccess.WRITE)
	var content = JSON.stringify(get_dict(), "\t") # Remove the tab to reduce file size someday?
	file.store_line(content)
	_set_is_dirty(false)
	if _close_after_save:
		_set_is_model(false)
	_reset_interface()
	
func get_dict() -> Dictionary:
	var dict = {}
	dict.set('actions', _model.get_action_dicts())
	dict.set('sensors', _model.get_sensor_dicts())
	return dict
	
	
func _set_is_model(is_model: bool, model_path: String = "") -> void:
	_is_model = is_model
	$SubHeader.visible = is_model
	$SubHeader.text = model_path.get_basename().get_file().capitalize()
	_model_path = model_path
	_reset_interface()
	$Timer.paused = !is_model
	
	
func _get_is_model() -> bool:
	return _is_model
	
	
func _get_is_model_file() -> bool:
	return _model_path != ""
	
	
func _on_edit_actions_model_changed() -> void:
	_set_is_dirty(true)
	
	
func _on_sensor_graph_model_changed() -> void:
	_set_is_dirty(true)
	_reset_interface()
	
	
func _set_is_dirty(is_dirty: bool) -> void:
	_is_dirty = is_dirty
	
	
## Edit Actions ##
func _on_edit_actions_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$ActionButtons.clear_action_buttons()
		$EditActions.set_actions(_model.get_actions())
		$EditActionsButton.text = "Done"
		_disable_interface()
		$EditActionsButton.disabled = false
	else:
		$ActionButtons.update_buttons();
		$EditActions.clear_edit_action_rows()
		$EditActionsButton.text = "Edit Actions"
		_reset_interface()
		
	$EditActions.visible = toggled_on


func _disable_interface() -> void:
	$ActionButtons.visible = false
	#$SensorGraph.visible = false
	$NewButton.disabled = true
	$OpenButton.disabled = true
	$CloseButton.disabled = true
	$SaveButton.disabled = true
	$SaveAsButton.disabled = true
	
	
func _reset_interface() -> void:
	$ActionButtons.visible = _is_model
	#$SensorGraph.visible = _is_model
	$NewButton.disabled = _is_model
	$OpenButton.disabled = _is_model
	$CloseButton.disabled = !_is_model
	$SaveButton.disabled = !_is_dirty
	$SaveAsButton.disabled = !_is_dirty
	$EditActionsButton.disabled = !_is_model
	
	
func _on_eye_button_toggled(toggled_on: bool) -> void:
	# Disable this until editing interface is implemented
	# if toggled_on:
	# $EditActionsButton.show()
	# else:
	# $EditActionsButton.hide()
	_model.set_edit_mode(toggled_on)
	$ActionButtons.show_hide_buttons()
	#$SensorGraph.update_edit_mode()
