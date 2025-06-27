extends Node3D

var state = 0
func build():
	state +=1
	match state:
		1:
			$Frigate01.show()
			var mat = $Frigate01.get_active_material(0)
			mat.cull_mode = 1
		2:
			var mat = $Frigate01.get_active_material(0)
			mat.cull_mode = 0
		3:
			$Frigate01.hide()
			state=0


func _on_build_button_down() -> void:
	build()
