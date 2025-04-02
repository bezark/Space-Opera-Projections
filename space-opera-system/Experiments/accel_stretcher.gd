extends CSGBox3D


func _on_joycon_accel_changed(accel):
	size.x = accel.x
	size.y = accel.y
	size.z = accel.z
	#print(size)
