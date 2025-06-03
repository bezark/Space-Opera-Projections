# Free-fly first-person camera (Godot 4)
# - Move with ui_up/down/left/right
# - Look with look_up/down/left/right
# Map your joysticks to those actions in Project Settings → InputMap.

extends Camera3D

@export var speed: float = 10.0
@export var look_sensitivity: float = 1.5

var yaw: float = 0.0    # rotation around Y
var pitch: float = 0.0  # rotation around X

func _ready():
	# Optional: lock mouse if you also want mouse look
	# Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _physics_process(delta):
	_process_movement(delta)
	_process_look(delta)


func _process_movement(delta):
	# Get movement input from "ui_up", "ui_down", "ui_left", "ui_right"
	var mv_forward = Input.get_action_strength("move_up")
	var mv_back    = Input.get_action_strength("move_down")
	var mv_right   = Input.get_action_strength("move_right")
	var mv_left    = Input.get_action_strength("move_left")

	# Compute a 2D vector on the XZ plane
	var input_dir = Vector2(
		mv_right - mv_left,
		mv_forward - mv_back
	)
	if input_dir.length_squared() > 0.0:
		input_dir = input_dir.normalized()
		# In Godot, forward is -Z, right is +X
		var forward = -transform.basis.z
		var right   = transform.basis.x
		var velocity = (forward * input_dir.y + right * input_dir.x) * speed * delta
		translate(velocity)


func _process_look(delta):
	# Get look input from "look_up", "look_down", "look_left", "look_right"
	var look_h = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var look_v = Input.get_action_strength("look_down")  - Input.get_action_strength("look_up")

	# Apply sensitivity & delta
	yaw   -= look_h * look_sensitivity * delta
	pitch -= look_v * look_sensitivity * delta

	# Clamp pitch to avoid flipping (±90°)
	pitch = clamp(pitch, -PI/2, PI/2)

	rotation = Vector3(pitch, yaw, 0.0)
