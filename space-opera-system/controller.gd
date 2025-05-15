extends Window

signal datapad_sync_changed(bool)

func _ready() -> void:
	get_tree().tree_changed.connect(check_for_controls)


func check_for_controls():
	var new_controls = get_tree().get_nodes_in_group("controller")
	if new_controls.size():
		for nc in new_controls:
			nc.call_deferred("reparent", %ActiveSceneControls)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#TODO: add a check!!!
		get_tree().quit()


func _on_datapad_sync_toggled(toggled_on: bool) -> void:
	datapad_sync_changed.emit(toggled_on)
