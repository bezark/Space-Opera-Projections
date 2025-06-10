extends CSGTorus3D
@export var spin_velocity = 1.0


func _process(delta: float) -> void:
	if $"..".armed:
		rotate_z(spin_velocity * delta)
	else:
		rotate_x(randf_range(-1., 1.) * spin_velocity * delta)
		rotate_y(randf_range(-1., 1.) * spin_velocity * delta)
		rotate_z(randf_range(-1., 1.) * spin_velocity * delta)
