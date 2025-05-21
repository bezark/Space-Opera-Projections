extends Control

signal datapad_sync_changed(bool)
signal scene_changed(scene:SceneData)

var datapad_syncing = true
@export var structure : SceneStructure

func _ready() -> void:
	var scene_button_group = ButtonGroup.new()
	for scene in structure.scene_data:
		var new_button = Button.new()
		new_button.button_group = scene_button_group
		new_button.text = scene
		new_button.toggle_mode = true
		%SceneControl.add_child(new_button)
		new_button.pressed.connect(scene_button_pressed.bind(scene))

	
	
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
	datapad_syncing = toggled_on
	datapad_sync_changed.emit(datapad_syncing)


func _on_datapad_sync_phase_changed(phase: Phase) -> void:
	check_for_controls.call_deferred()

func scene_button_pressed(val):
	if not datapad_syncing:
		scene_changed.emit(structure.scene_data[val])
		check_for_controls.call_deferred()
		


func _on_autosave_timeout() -> void:
	State.save()
