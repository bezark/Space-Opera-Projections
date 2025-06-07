extends Node3D
class_name CelestialBody

@export var title: String

@export var scene_data: SceneData

@export var body: Node3D

@export var sattelites: Array[Node]
@export var atmosphere : Node
@export var distance: float:
	set(val):
		distance = val
		if body:
			body.position.x = distance

@export var speed: float = 0.005:
	set(val):
		speed = val

@export var spin: float

@onready var controls = $VBoxContainer/Controls
@onready var all_controls: VBoxContainer = $VBoxContainer

#var crane :  Node3D

func _ready() -> void:
	if scene_data:
		if scene_data.scene:
			for dk in get_children():
				if !dk.is_in_group("system_control"):
					dk.queue_free()
			var new_body = scene_data.scene.instantiate()
			add_child(new_body)
			body = new_body

	var parent = get_parent()

	if sattelites.size():
		for sattelite in sattelites:
			var remote_transform = RemoteTransform3D.new()
			remote_transform.update_rotation = false
			remote_transform.remote_path = sattelite.get_path()
			body.add_child(remote_transform)
		# sattelite.add_to_group("point_of_interest")
	print(name)
	$VBoxContainer/Title.text = body.name
	if body:
		distance = body.position.x
		#body.add_to_group("point_of_interest")

	rotation.y = fmod(speed * Time.get_unix_time_from_system(), TAU)
	$VBoxContainer/Controls/Sliders/Distance.value = distance
	$VBoxContainer/Controls/Sliders/Speed.value = speed
	$VBoxContainer/Controls/Sliders/Spin.value = spin


func _process(delta: float) -> void:
	rotate_y(speed * delta)
	body.rotate_y(spin * delta)


func _on_distance_value_changed(value: float) -> void:
	distance = value


func _on_speed_value_changed(value: float) -> void:
	speed = value


func _on_spin_value_changed(value: float) -> void:
	spin = value


func _on_title_toggled(toggled_on: bool) -> void:
	controls.visible = toggled_on


func _on_delete_pressed() -> void:
	State.celestial_body_deleted.emit()
	all_controls.queue_free()
	var kids = get_children()
	var crane = body.find_child('Crane')
	if crane:
		var kin = find_parent("Kin")
		crane.reparent(kin)
	queue_free()
	
