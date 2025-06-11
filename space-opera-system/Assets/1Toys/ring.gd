extends CSGTorus3D
@export var spin_velocity = 1.0

@export var spin: Vector3


func _ready() -> void:
	spin = Vector3(randf_range(-1., 1.), randf_range(-1., 1.), randf_range(-1., 1.))


func _process(delta: float) -> void:
	if $"../..".armed:
		var local_z_in_world: Vector3 = transform.basis.y.normalized()
		rotate(local_z_in_world, spin_velocity * delta)

	# 	#rotate_object_local(rotation.normalized(), spin_velocity)
	# 	rotate_z(spin_velocity * delta)
	# #else:
	#print("sdfsdf")
	#rotate_x(spin.x * spin_velocity * delta)
	#rotate_y(spin.y * spin_velocity * delta)
	#rotate_z(spin.z * spin_velocity * delta)
