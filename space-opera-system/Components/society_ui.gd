extends Control


func _on_control_action_toggled(visible: bool) -> void:
	pass  # Replace with function body.


func _on_control_cam_toggled(visible: bool) -> void:
	if visible:
		$AnimationPlayer.play("DiceCamUp")
	else:
		$AnimationPlayer.play("DiceCamDown")


func _on_control_next_society_pressed() -> void:
	pass  # Replace with function body.


func _on_control_prev_society_pressed() -> void:
	pass  # Replace with function body.


func _on_control_society_complete_pressed() -> void:
	pass  # Replace with function body.


func _on_control_ui_toggeled(visible: bool) -> void:
	
	if visible:
		$AnimationPlayer.play("UIUp")
	else:
		$AnimationPlayer.play("UIDown")


func _on_control_society_focused(action: SocietyAction) -> void:
	var active_soc = State.societies[action.parent_society]
	$SocietyName.text = active_soc.archetype.title
	$Icon.texture = active_soc.archetype.star_sign
