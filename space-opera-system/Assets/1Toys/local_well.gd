extends CSGSphere3D


func _on_button_toggled(toggled_on: bool) -> void:
	$CSGCylinder3D.visible = toggled_on
	$ElectricExplosion.auto_animate = toggled_on
