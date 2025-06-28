extends Node3D


func _on_fucked_toggled(toggled_on: bool) -> void:
	$FuckedBelt.visible = toggled_on
	$Normal.visible = !toggled_on
