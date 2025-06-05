extends Node3D
class_name CelestialBody


@export var title: String
@export var body: Node3D
var key: String

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
@export var zooms : Array[PackedScene]

@onready var controls: GridContainer = $VBoxContainer/Controls


func _ready() -> void:
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
