extends Node3D

var progress = 0


func _on_build_button_down() -> void:
	progress += 1
	if progress >2:
		progress = 0
	match progress:
		0:
			$Progress.hide()
			$Finished.hide()
		1:
			$Progress.show()
		2:
			$Progress.hide()
			$Finished.show()
