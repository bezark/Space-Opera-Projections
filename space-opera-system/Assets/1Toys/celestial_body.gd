extends Node3D
class_name CelestialBody

@export var title: String

@export var scene_data: SceneData

@export var body: Node3D

@export var sattelite: CelestialBody = null
@export var distance: float:
	set(val):
		distance = val
		if body:
			body.position.x = distance

@export var speed: float = 0.005:
	set(val):
		speed = val

@export var spin: float

@onready var controls: GridContainer = $VBoxContainer/Controls


func _ready() -> void:
	if scene_data:
		var new_body = scene_data.scene.instantiate()
		add_child(new_body)
		body = new_body
	var parent = get_parent()

	if sattelite:
		var remote_transform = RemoteTransform3D.new()
		remote_transform.update_rotation = false
		remote_transform.remote_path = sattelite.get_path()
		body.add_child(remote_transform)
		# sattelite.add_to_group("point_of_interest")
	$VBoxContainer/Title.text = title
	if body:
		distance = body.position.x
		body.add_to_group("point_of_interest")

	rotation.y = fmod(speed * Time.get_unix_time_from_system(), TAU)
	$VBoxContainer/Controls/Distance.value = distance
	$VBoxContainer/Controls/Speed.value = speed
	$VBoxContainer/Controls/Spin.value = spin


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
