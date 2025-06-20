extends Node3D


func _on_upload_toggled(toggled_on: bool) -> void:
	for parti in get_children():
		parti.emitting = toggled_on
