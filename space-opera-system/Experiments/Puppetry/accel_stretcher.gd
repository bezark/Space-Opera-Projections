extends CSGBox3D

@export var weight = 0.01
func _on_joycon_accel_changed(accel):
	var new_size = Vector3(accel.x, accel.y, accel.z)
	size = lerp(size, new_size, weight)
	
