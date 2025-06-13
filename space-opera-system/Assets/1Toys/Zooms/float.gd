extends PathFollow3D


func _process(delta: float) -> void:
	progress_ratio+=delta*0.01
