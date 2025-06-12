extends Node3D




func _on_parties_toggled(toggled_on: bool) -> void:
	$GPUParticles3D.emitting = toggled_on
	$GPUParticles3D2.emitting = toggled_on
