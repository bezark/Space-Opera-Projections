@tool
extends Control

signal datapad_sync_changed(bool)
signal scene_changed(scene: SceneData)

var datapad_syncing = true
var selected_scene_data: SceneData
var selected_id : String
@export var structure: SceneStructure


func _ready() -> void:
	make_buttons()
func make_buttons():
	for ded_kid in %  SceneControl.get_children():
		ded_kid.queue_free()
	var scene_button_group = ButtonGroup.new()
	for phase in State.phases:
		var new_button = Button.new()
		new_button.button_group = scene_button_group
		new_button.text = phase.type
		new_button.toggle_mode = true
		new_button.name = phase.id
		%SceneControl.add_child(new_button)
		new_button.pressed.connect(scene_button_pressed.bind(phase.scene_data,new_button.name))
	if selected_id:
		%SceneControl.get_node(selected_id).button_pressed = true
	# for scene in structure.scene_data:
	# 	var new_button = Button.new()
	# 	new_button.button_group = scene_button_group
	# 	new_button.text = scene
	# 	new_button.toggle_mode = true
	# 	%SceneControl.add_child(new_button)
	# 	new_button.pressed.connect(scene_button_pressed.bind(scene))


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
	if datapad_syncing:
		var button: Button = %SceneControl.get_node(phase.id)
		if button:
			button.button_pressed = true
		scene_changed.emit(phase.scene_data)
		check_for_controls.call_deferred()


func scene_button_pressed(val, id):
	selected_scene_data = val
	selected_id = id
	if not datapad_syncing:
		scene_changed.emit(val)
		check_for_controls.call_deferred()


func _on_autosave_timeout() -> void:
	State.save()


func _on_make_unique_pressed() -> void:
	var new_scenedata :SceneData= selected_scene_data.duplicate(true)
	var new_scene = new_scenedata.scene
	var new_path = str("res://Phases/Overrides/",selected_id,'.tscn')
	ResourceSaver.save(new_scene, new_path)
	new_scenedata.scene = load(new_path)
	var phase_to_change = State.phases.find_custom(func(elem):
				return elem["id"] == selected_id
				)
	State.phases[phase_to_change].scene_data = new_scenedata
	State.save()
	selected_scene_data = new_scenedata
	State.load_state()
	make_buttons()
	open_scene_message()
	pass  # Replace with function body.


func _on_open_pressed() -> void:
	open_scene_message()

func open_scene_message():
	var peer = StreamPeerTCP.new()
	if peer.connect_to_host("127.0.0.1", 7878) == OK:
		peer.poll()
		peer.put_var(selected_scene_data.scene.resource_path)
		peer.disconnect_from_host()
	else:
		push_error("Couldn’t talk to the editor plugin!")

	
	
	#SceneOpen.switch_scene(scene_path)
	
	#open_scene_from_path(scene_path)
