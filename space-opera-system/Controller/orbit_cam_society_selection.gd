extends HBoxContainer

@onready var orbital_camera: OrbitalCamera = $"../.."

@export var system: Node3D
@onready var controller: Control = $"../../../../../../Control"


func _ready() -> void:
	for society_id in State.societies:
		var society = State.societies[society_id]
		var new_button = SocietyButton.new()
		new_button.society = society
		new_button.society_selected.connect(focus_on_home)
		add_child(new_button)


func focus_on_home(society: Society):
	var packed_home: PackedScene = society.home.scene
	var home = system.find_child(packed_home.get_state().get_node_name(0))

	# print(home)
	# var focus = get_node(focus_path)
	controller.make_zoom_buttons(society.home)
	orbital_camera.focus = home.get_parent()
	orbital_camera.start()


func _on_control_society_focused(action: SocietyAction) -> void:
	focus_on_home(State.societies[action.parent_society])


func _on_control_next_society_pressed(action: SocietyAction) -> void:
	await get_tree().create_timer(0.8).timeout
	focus_on_home.call_deferred(State.societies[action.parent_society])
	


func _on_control_prev_society_pressed(action: SocietyAction) -> void:
	await get_tree().create_timer(0.8).timeout
	focus_on_home.call_deferred(State.societies[action.parent_society])
	
