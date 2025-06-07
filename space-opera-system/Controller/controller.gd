extends Control

signal datapad_sync_changed(bool)
signal scene_changed(scene: SceneData)
signal zoomed_in(zoom: PackedScene)

signal view_fade_adjusted(val: float)
signal controls_updated

@export var structure: SceneStructure

signal body_added(scene_data: SceneData)
@export var system_view: ViewportTexture

var datapad_syncing = true
var selected_scene_data: SceneData
var selected_id: String


func _ready() -> void:
	#var window = get_viewport()
	#window.title="Controller"
	make_phase_buttons()
	check_for_controls.call_deferred()
	State.celestial_body_deleted.connect(check_for_controls)
	#o%SystemView.set_deferred("texture", system_view)


func make_phase_buttons():
	for ded_kid in %PhaseSelect.get_children():
		ded_kid.queue_free()
	var scene_button_group = ButtonGroup.new()
	for phase in State.phases:
		var new_button = Button.new()
		new_button.button_group = scene_button_group
		new_button.text = phase.type
		new_button.toggle_mode = true
		new_button.name = phase.id
		%PhaseSelect.add_child(new_button)
		new_button.pressed.connect(scene_button_pressed.bind(phase.scene_data, new_button.name))
	if selected_id:
		%PhaseSelect.get_node(selected_id).button_pressed = true


func make_zoom_buttons(scene_data: SceneData):
	for ded_kid in %ZoomSelect.get_children():
		ded_kid.queue_free()
	var scene_button_group = ButtonGroup.new()
	if scene_data.zooms.size():
		for zoom in scene_data.zooms:
			var new_button = Button.new()
			new_button.button_group = scene_button_group
			new_button.text = zoom.get_state().get_node_name(0)
			new_button.toggle_mode = true
			# new_button.name = phase.id
			%ZoomSelect.add_child(new_button)
			new_button.pressed.connect(zoom_button_pressed.bind(zoom))
	if selected_id:
		%PhaseSelect.get_node(selected_id).button_pressed = true
	# for scene in structure.scene_data:
	# 	var new_button = Button.new()
	# 	new_button.button_group = scene_button_group
	# 	new_button.text = scene
	# 	new_button.toggle_mode = true
	# 	%SceneControl.add_child(new_button)
	# 	new_button.pressed.connect(scene_button_pressed.bind(scene))

func defered_check():
	call_deferred("check_for_controls")
func check_for_controls():
	print('checkin...')
	check_for_system_controls()
	check_for_zoom_controls()
	check_for_ui_controls()
	controls_updated.emit()


func check_for_system_controls():
	var new_controls = get_tree().get_nodes_in_group("system_control")
	print(new_controls)
	for nc in new_controls:
		nc.call_deferred("reparent", %SystemControls)


func check_for_zoom_controls():
	var new_controls = get_tree().get_nodes_in_group("zoom_control")
	var ded_kidz = %ZoomControls.get_children()
	for kid in ded_kidz:
		if not kid.is_in_group("permanent"):
			kid.queue_free()
	for nc in new_controls:
		nc.call_deferred("reparent", %ZoomControls)
	


func check_for_ui_controls():
	var new_controls = get_tree().get_nodes_in_group("ui_control")
	var ded_kidz = %UIControls.get_children()
	for kid in ded_kidz:
		if not kid.is_in_group("permanent"):
			kid.queue_free()
	for nc in new_controls:
		nc.call_deferred("reparent", %UIControls)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#TODO: add a check!!!
		get_tree().quit()


func _on_datapad_sync_toggled(toggled_on: bool) -> void:
	datapad_syncing = toggled_on
	datapad_sync_changed.emit(datapad_syncing)


func _on_datapad_sync_phase_changed(phase: Phase) -> void:
	if datapad_syncing:
		var button: Button = %PhaseSelect.get_node(phase.id)
		if button:
			button.button_pressed = true
		scene_changed.emit(phase.scene_data)
		make_zoom_buttons(phase.scene_data)
		check_for_controls.call_deferred()


func scene_button_pressed(val, id):
	selected_scene_data = val
	selected_id = id
	if not datapad_syncing:
		scene_changed.emit(val)
		make_zoom_buttons(val)
		check_for_controls.call_deferred()


func zoom_button_pressed(zoom):
	zoomed_in.emit(zoom)
	check_for_controls.call_deferred()


func _on_autosave_timeout() -> void:
	State.save()


func _on_make_unique_pressed() -> void:
	#var new_scenedata :SceneData= selected_scene_data.duplicate(true)
	#var new_scene = new_scenedata.scene
	#var new_path = str("res://Phases/Overrides/",selected_id,'.tscn')
	#ResourceSaver.save(new_scene, new_path)
	#new_scenedata.scene = load(new_path)
	#var phase_to_change = State.phases.find_custom(func(elem):
	#return elem["id"] == selected_id
	#)
	#State.phases[phase_to_change].scene_data = new_scenedata
	#State.save()
	#selected_scene_data = new_scenedata
	#State.load_state()
	#make_phase_buttons()
	#open_scene_message()
	pass  # Replace with function body.


func _on_open_pressed() -> void:
	open_scene_message(selected_scene_data, false)


func open_scene_message(scene_data: SceneData, zoomed: bool):
	var peer = StreamPeerTCP.new()
	if peer.connect_to_host("127.0.0.1", 7878) == OK:
		peer.poll()
		if zoomed:
			for zoom in scene_data.zooms:
				peer.put_var(zoom.resource_path)
		else:
			peer.put_var(scene_data.scene.resource_path)
		peer.disconnect_from_host()
	else:
		push_error("Couldn’t talk to the editor plugin!")

	#SceneOpen.switch_scene(scene_path)

	#open_scene_from_path(scene_path)


func zoom_slider_value_changed(value: float) -> void:
	view_fade_adjusted.emit(value)


func _on_celestial_body_add_body_selected(scene_data: SceneData) -> void:
	selected_scene_data = scene_data


func _on_add_pressed() -> void:
	body_added.emit(selected_scene_data)
