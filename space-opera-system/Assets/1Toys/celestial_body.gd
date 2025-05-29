extends Node3D
class_name CelestialBody

@export var title: String
@export var body : Node3D
@export var distance :float :
	set(val):
		distance = val
		if body:	
			body.position.x = distance
@export var speed: float = 0.5:
	set(val):
		offset = rotation.y - val*Time.get_unix_time_from_system()
		speed = val
		
@export var spin :float

var offset = 0.0

func _ready() -> void:
	$VBoxContainer/Title.text = title
	if body:
		distance = body.position.x
	offset = rotation.y - speed*Time.get_unix_time_from_system()
	
func _process(delta: float) -> void:
	var angle = fmod(Time.get_unix_time_from_system()*speed+offset, TAU)
	rotation.y = angle


func _on_distance_value_changed(value: float) -> void:
	distance = value


func _on_speed_value_changed(value: float) -> void:
	speed = value

func _on_spin_value_changed(value: float) -> void:
	spin = value
