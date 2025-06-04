extends SystemCamera
class_name OrbitalCamera

@export var focus: Node3D
@export var sensitivity := 0.005    # adjust to speed up/slow down response
@export var damping := 5.0          # how quickly the rotation “slows down”

var crane: Node3D
var angular_velocity := Vector2.ZERO  # stores last drag velocity (px/frame)

func _ready():
	crane = get_parent_node_3d()
	start(focus)


func start(new_focus: Node3D) -> void:
	focus = new_focus
	# reparent the crane to the focus so its origin is at the focus point
	crane.position = focus.global_transform.origin
	crane.call_deferred("reparent", focus)
	
	# point the camera at the focus
	look_at(focus.global_transform.origin, Vector3.UP)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		# store the raw drag delta (pixels) for _process to consume
		angular_velocity = event.relative
		

func _process(delta: float) -> void:
	if angular_velocity.length() > 0.01:
		# convert px to radians and apply
		var yaw_amount   = -angular_velocity.x * sensitivity * delta
		var pitch_amount = -angular_velocity.y * sensitivity * delta

		# always rotate horizontally around global Y
		crane.rotate(Vector3.UP, yaw_amount)
		# rotate vertically around crane’s local X
		crane.rotate_object_local(Vector3.RIGHT, pitch_amount)

		# decay angular_velocity toward zero
		angular_velocity = angular_velocity.lerp(Vector2.ZERO, damping * delta)
