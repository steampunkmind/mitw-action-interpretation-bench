extends ColorRect

const DONT_SAVE = "Don't Save"

var _aim_model: ActionInfluenceModel
var _gam_model: GovernorActionModel
var _is_aim_model: bool = false
var _is_gam_model: bool = false
var _aim_model_path: String = ""
var _gam_model_path: String = ""
var _is_dirty: bool = false
var _close_after_save: bool = false

@export var frame_rate: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FrameRateSlider.value = frame_rate
	$FrameRateValue.text = str(frame_rate)
	$CloseConfirmationDialog.add_button(DONT_SAVE, false, DONT_SAVE)
	_set_is_aim_model(false)
	_set_is_dirty(false)
	$OpenFileDialog.set_current_dir("models")
	$SaveFileDialog.set_current_dir("models")
	_aim_model = ActionInfluenceModel.new()
	SensorFormula.model = _aim_model # set global var
	SensorFormula.action_agent = $ActionButtons # set global var
	$ActionButtons.set_aim_model(_aim_model)
	$SensorDisplay.set_aim_model(_aim_model)
	_gam_model = GovernorActionModel.new()
	$GovernorDisplay.set_models(_aim_model, _gam_model)
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
	$SensorDisplay.update_sensor_values()


func _on_action_button_pressed(action: Action) -> void:
	$SensorDisplay.set_action(action)


## File Functions ##
func _on_new_button_pressed() -> void:
	$ActionButtons.set_new_model()
	$SensorDisplay.set_new_model()
	$ActionButtons.init_action()


func _on_open_aim_button_pressed() -> void:
	$OpenFileDialog.set_filters(["*.aim"])
	$OpenFileDialog.popup()


func _on_close_aim_button_pressed() -> void:
	if _is_dirty:
		$CloseConfirmationDialog.popup()
	else:
		_set_is_dirty(false)
		_set_is_aim_model(false)


func _on_open_gam_button_pressed() -> void:
	$OpenFileDialog.set_filters(["*.gam"])
	$OpenFileDialog.popup()


func _on_close_gam_button_pressed() -> void:
	_set_is_gam_model(false)


func _on_open_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	if !_is_aim_model:
		_aim_model.set_action_dicts(json.get('actions') as Array)
		_aim_model.set_sensor_dicts(json.get('sensors') as Array)
		$ActionButtons.update_buttons()
		$SensorDisplay.update_sensors()
		$ActionButtons.init_action()
		_set_is_aim_model(true, path)
	else:
		_gam_model.set_governor_dicts(json.get('governors') as Array, _aim_model)
		$GovernorDisplay.update_governors()
		_set_is_gam_model(true, path)


func _on_close_confirmation_dialog_confirmed() -> void:
	_close_after_save = true
	if (!_get_is_model_file()):
		$SaveFileDialog.popup()
	else:
		_write_file()


func _on_close_confirmation_dialog_custom_action(action: StringName) -> void:
	if action == DONT_SAVE:
		_set_is_dirty(false)
		_set_is_aim_model(false)
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
	_set_is_aim_model(true, path)
	_write_file()


func _write_file() -> void:
	var file = FileAccess.open(_gam_model_path, FileAccess.WRITE)
	var content = JSON.stringify(get_dict(), "\t") # Remove the tab to reduce file size someday?
	file.store_line(content)
	_set_is_dirty(false)
	if _close_after_save:
		_set_is_aim_model(false)
	_reset_interface()


func get_dict() -> Dictionary:
	var dict = {}
	dict.set('actions', _aim_model.get_action_dicts())
	dict.set('sensors', _aim_model.get_sensor_dicts())
	return dict


func _set_is_aim_model(is_aim_model: bool, model_path: String = "") -> void:
	_is_aim_model = is_aim_model
	#$SubHeader.visible = is_aim_model
	#$SubHeader.text = model_path.get_basename().get_file().capitalize()
	_aim_model_path = model_path
	_reset_interface()
	#$Timer.paused = !is_aim_model


func _get_is_aim_model() -> bool:
	return _is_aim_model

func _set_is_gam_model(is_gam_model: bool, model_path: String = "") -> void:
	_is_gam_model = is_gam_model
	_gam_model_path = model_path
	$SubHeader.visible = is_gam_model
	var aim_name = _aim_model_path.get_basename().get_file().capitalize()
	var gam_name = _gam_model_path.get_basename().get_file().capitalize()
	
	$SubHeader.text = aim_name + " - " + gam_name
	_reset_interface()
	$Timer.paused = !is_gam_model
	
	
func _get_is_model_file() -> bool:
	return _gam_model_path != ""


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
		$EditActions.set_actions(_aim_model.get_actions())
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
	$SensorDisplay.visible = false
	$GovernorDisplay.visible = false
	$NewButton.disabled = true
	$OpenAIMButton.disabled = true
	$CloseAIMButton.disabled = true
	$OpenGAMButton.disabled = true
	$CloseGAMButton.disabled = true
	$SaveButton.disabled = true
	$SaveAsButton.disabled = true


func _reset_interface() -> void:
	$ActionButtons.visible = _is_aim_model
	$SensorDisplay.visible = _is_aim_model
	$GovernorDisplay.visible = _is_gam_model
	$NewButton.disabled = _is_aim_model
	$OpenAIMButton.disabled = _is_aim_model
	$CloseAIMButton.disabled = !_is_aim_model or _is_gam_model
	$OpenGAMButton.disabled = !_is_aim_model or _is_gam_model
	$CloseGAMButton.disabled = !_is_gam_model
	$SaveButton.disabled = !_is_dirty
	$SaveAsButton.disabled = !_is_dirty
	$EditActionsButton.disabled = !_is_aim_model


func _on_eye_button_toggled(toggled_on: bool) -> void:
	_aim_model.set_edit_mode(toggled_on)
	$ActionButtons.show_hide_buttons()
