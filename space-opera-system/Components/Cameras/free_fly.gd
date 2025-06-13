# Free‐fly first‐person camera (Godot 4)
# – Movement is now always relative to where the camera is looking.
# – Pulling the stick “back” moves you backwards, no matter how you’ve turned.
# – Look is unchanged from before.

extends SystemCamera
class_name FreeFlyCamera

@export var orbital: SystemCamera

@export var speed: float = 6.0
@export var look_sensitivity: float = 0.4
@export var planetary: bool = true
var active :bool
var yaw: float = 0.0  # rotation around Y
var pitch: float = 0.0  # rotation around X

func _ready() -> void:
	State.zoomed_in.connect(activate)
	active = !planetary
	
func activate(value):
	if planetary:
		active = value
		
		
func start():
	if orbital:
		# global_position = orbital.global_position
		# rotation = orbital.rotation
		global_transform = orbital.global_transform
		look_at(orbital.focus.body.global_transform.origin, Vector3.UP)
		yaw = rotation.y
		pitch = rotation.x


func _physics_process(delta):
	if active:
		_process_look(delta)
		_process_movement(delta)
	pass


func _process_look(delta):
	var look_h = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var look_v = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")

	yaw -= look_h * look_sensitivity * delta
	pitch -= look_v * look_sensitivity * delta
	pitch = clamp(pitch, -PI / 2, PI / 2)

	rotation = Vector3(pitch, yaw, 0.0)


func _process_movement(delta):
	var mv_forward = Input.get_action_strength("move_up")
	var mv_back = Input.get_action_strength("move_down")
	var mv_right = Input.get_action_strength("move_right")
	var mv_left = Input.get_action_strength("move_left")

	var input_dir = Vector2(mv_right - mv_left, mv_forward - mv_back)
	if input_dir.length_squared() > 0.0:
		input_dir = input_dir.normalized()
		# Because translate() is LOCAL:
		#   X = right, Z = forward (negative Z axis is “forward” in Godot).
		# So we invert the Y component for “forward/back”:
		var local_offset = Vector3(input_dir.x, 0, -input_dir.y) * speed * delta
		translate(local_offset)
