extends SystemCamera
class_name OrbitalCamera

@export var focus: CelestialBody
@export var sensitivity := 1.5  # how fast the camera turns per “unit” joystick input
@export var damping := 4.0  # how quickly inertia decays (larger == stops faster)
@export var deadzone := 0.2  # ignore any stick input smaller than this
@export var zoom_sensitivity := 2.0
@export var default_zoom = 20.

@export var points_of_interest: Array[Node]

var crane: Node3D
var angular_velocity := Vector2.ZERO  # stored “velocity” from last frame


func _ready():
	points_of_interest = get_tree().get_nodes_in_group("point_of_interest")
	crane = get_parent_node_3d()
	focus = points_of_interest.pick_random()
	if not State.celestial_body_focused.is_connected(new_focus):
		State.celestial_body_focused.connect(new_focus)
	# (Optionally call start() here if you want to pick a random POI on start)
	# start()
	# %BodySelection.pois = points_of_interest
	# %BodySelection.make_poi_buttons()


func new_focus(body: CelestialBody):
	focus = body
	start()


func start() -> void:
	crane.global_position = focus.body.global_position
	global_position = focus.body.global_position
	position.z += default_zoom
	crane.call_deferred("reparent", focus.body)
	look_at(focus.body.global_transform.origin, Vector3.UP)


# func fly() -> void:
# 	crane.global_position = focus.body.global_position
# 	global_position = focus.body.global_position
# 	position.z += default_zoom
# 	crane.call_deferred("reparent", focus.body)
# 	look_at(focus.body.global_transform.origin, Vector3.UP)


func _process(delta: float) -> void:
	# if focus:
	# 	look_at(focus.global_transform.origin, focus.transform.basis.y)

	# 1) Read raw joystick/twin-stick input each frame:
	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# (If you have an actual analog gamepad axis, you can also do:
	#    var raw_x := Input.get_action_strength("joy_right") - Input.get_action_strength("joy_left")
	#    var raw_y := Input.get_action_strength("joy_down") - Input.get_action_strength("joy_up")
	#    var raw_input := Vector2(raw_x, raw_y)
	# )

	# 2) Apply deadzone so tiny stick noise is ignored:
	if raw_input.length() < deadzone:
		raw_input = Vector2.ZERO

	# 3) If the stick is pushed, overwrite our angular_velocity:
	if raw_input != Vector2.ZERO:
		# scale it however you like—here, sensitivity acts like “max radians/sec”
		angular_velocity = raw_input * sensitivity

	# 4) Use that stored angular_velocity (in “units/sec”) to rotate:
	if angular_velocity.length() > 0.01:
		# Note: angular_velocity is in “unit/sec”, so multiply by `delta` to get “units this frame”:
		var yaw_amount := -angular_velocity.x * delta
		var pitch_amount := -angular_velocity.y * delta

		# Yaw around **world Y** so horizontal-stick always orbits nicely:
		crane.rotate(Vector3.UP, yaw_amount)
		# Pitch around the **crane’s local X** so vertical-stick always tilts “up/down” relative to current orientation:
		crane.rotate_object_local(Vector3.RIGHT, pitch_amount)

		# 5) Now decay the stored velocity toward zero when stick is let go:
		angular_velocity = angular_velocity.lerp(Vector2.ZERO, damping * delta)

	# If angular_velocity is almost zero by now, we do nothing this frame.

	var zoom_input = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")

	var zoom_amount_this_frame = zoom_input * zoom_sensitivity * delta
	translate(Vector3(0, 0, zoom_amount_this_frame))
	# print(global_position)
