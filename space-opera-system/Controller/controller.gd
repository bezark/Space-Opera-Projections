extends Window

signal datapad_sync_changed(bool)
@export var structure : SceneStructure

func _ready() -> void:
	for scene in structure.scene_data:
		pass

func check_for_controls():
	var new_controls = get_tree().get_nodes_in_group("controller")
	
	var ded_kidz = %ActiveSceneControls.get_children()
	for kid in ded_kidz:
		kid.queue_free()
	for nc in new_controls:
		nc.call_deferred("reparent", %ActiveSceneControls)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#TODO: add a check!!!
		get_tree().quit()


func _on_datapad_sync_toggled(toggled_on: bool) -> void:
	datapad_sync_changed.emit(toggled_on)



func _on_datapad_sync_phase_changed(phase: Phase) -> void:
	check_for_controls.call_deferred()
