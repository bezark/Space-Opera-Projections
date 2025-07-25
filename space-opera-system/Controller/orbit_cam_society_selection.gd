extends HFlowContainer

@onready var orbital_camera: OrbitalCamera = $"../.."

@export var system: Node3D
@onready var controller: Control = $"../../../../../../Control"
var next_soc: Society
var home
var focus_index : String


func _ready() -> void:
	for society_id in State.societies:
		var society = State.societies[society_id]
		var new_button = SocietyButton.new()
		new_button.society = society
		new_button.society_selected.connect(focus_on_home)
		add_child(new_button)


func focus_on_home(society: Society):
	var packed_home: PackedScene = society.home.scene
	focus_index = State.societies.find_key(society)
	home = system.find_child(packed_home.get_state().get_node_name(0))
	controller.make_zoom_buttons(society.home)
	fly_home()


func quick_focus_on_home(society: Society):
	var packed_home: PackedScene = society.home.scene
	home = system.find_child(packed_home.get_state().get_node_name(0))
	controller.make_zoom_buttons(society.home)


func fly_home():
	orbital_camera.focus = home.get_parent()
	orbital_camera.start()


func _on_control_society_focused(action: SocietyAction) -> void:
	focus_on_home(State.societies[action.parent_society])


func _on_control_next_society_pressed(action: SocietyAction) -> void:
	next_soc = State.societies[action.parent_society]
	quick_focus_on_home(next_soc)
	$Delay.start()


func _on_control_prev_society_pressed(action: SocietyAction) -> void:
	next_soc = State.societies[action.parent_society]
	quick_focus_on_home(next_soc)
	$Delay.start()


func _on_delay_timeout() -> void:
	orbital_camera.focus = home.get_parent()
	orbital_camera.start()


func _on_control_society_fake_focused() -> void:
	var dummy = SocietyAction.new()
	dummy.parent_society = focus_index
	controller.society_focused.emit(dummy)
