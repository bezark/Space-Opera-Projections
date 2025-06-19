extends Node3D


func _on_button_toggled(toggled_on: bool) -> void:
	$BEAM.visible = toggled_on


func _on_button_2_toggled(toggled_on: bool) -> void:
	$FreeFlyCamera/GPUParticles3D.emitting = toggled_on
