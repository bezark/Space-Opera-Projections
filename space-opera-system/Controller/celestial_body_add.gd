extends VBoxContainer

@export var all_bodies: AllCelestialBodies
signal body_selected(scene_data: SceneData)


func _ready() -> void:
	var new_button_group = ButtonGroup.new()
	for body: SceneData in all_bodies.all_bodies:
		var new_button = Button.new()
		new_button.button_group = new_button_group
		new_button.text = body.scene.get_state().get_node_name(0)
		$ScrollContainer/Buttons.add_child(new_button)
		new_button.pressed.connect(scene_button_pressed.bind(body))


func scene_button_pressed(scene_data: SceneData):
	body_selected.emit(scene_data)
