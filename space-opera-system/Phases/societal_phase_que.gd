extends Control


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("UIUp")
	else:
		$AnimationPlayer.play("UIDown")
