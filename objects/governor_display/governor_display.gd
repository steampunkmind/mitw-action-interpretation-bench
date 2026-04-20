class_name GovernorDisplay extends ColorRect

@export var governor_display_row_template: PackedScene

var governor_display_rows: Dictionary[String, GovernorDisplayRow]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_governors() -> void:
	clear_governor_display_rows()
	add_governor_display_rows()


func refresh() -> void:
	for governor_display_row: GovernorDisplayRow in governor_display_rows.values():
		governor_display_row.refresh()


func clear_governor_display_rows() -> void:
	for governor_row: GovernorDisplayRow in governor_display_rows.values():
		remove_child(governor_row)
	
	governor_display_rows.clear()


func add_governor_display_rows() -> void:
	var header_margin = 98
	var row_margin = 10
	var row_location = header_margin
	for governor: Governor in MITW.gam_model().get_governors():
		var row = governor_display_row_template.instantiate()
		row.init(MITW.aim_model(), MITW.gam_model(), governor, row_location)
		add_child(row)
		governor_display_rows.set(governor.get_name(), row)
		row_location = row_location + 58
