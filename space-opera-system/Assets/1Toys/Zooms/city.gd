extends Node3D


func _on_parties_toggled(toggled_on: bool) -> void:
	$Camera3D/GPUParticles3D.emitting = toggled_on
	$Camera3D/GPUParticles3D2.emitting = toggled_on


func _on_flyby_pressed() -> void:
	$AnimationPlayer.play("flyby")


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$Buildings.material_overlay.albedo_color = Color(0.5, 0.25, 0.25, 1.0)
		$EmberShips.visible = true
	else:
		$Buildings.material_overlay.albedo_color = Color(0, 0, 0, 0)
		$EmberShips.visible = false
