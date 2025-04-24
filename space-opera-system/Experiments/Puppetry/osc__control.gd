extends Node3D

var axis = {
	"x" :  Vector3.LEFT,
	"y" : Vector3.DOWN,
	"z" : Vector3.BACK
}
func _on_osc_server_message_received(address: Variant, value: Variant, time: Variant) -> void:
	var add_array = address.split("/")

	prints(address, value)
	#if add_array[1]== "gyro":
		#$CSGBox3D.rotate(axis[add_array[2]],remap(value, 0., 1., -0.05, 0.05))
		##print($CSGBox3D.rotation_degrees)
