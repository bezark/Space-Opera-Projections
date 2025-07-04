extends Blackhole

@export var speed: float = 3.0
@export var look_sensitivity: float = 0.1
@export var planetary: bool = true
var active :bool
var yaw: float = 0.0  # rotation around Y
var pitch: float = 0.0  # rotation around X

func _process(delta):
	var look_h = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var look_v = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")

	yaw -= look_h * look_sensitivity * delta
	pitch -= look_v * look_sensitivity * delta
	pitch = clamp(pitch, -PI / 2, PI / 2)

	rotation = Vector3(pitch, yaw, 0.0)


func _on_button_pressed() -> void:
	pass # Replace with function body.
	$"../FreeFlyCamera/Effects"


func _on_button_toggled(toggled_on: bool) -> void:
	$"../FreeFlyCamera/Effects".visible = toggled_on
