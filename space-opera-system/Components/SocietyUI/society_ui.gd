extends Control


func _on_control_action_toggled(visible: bool) -> void:
	if visible:
		$AnimationPlayer.play("ActionUp")
	else:
		$AnimationPlayer.play("ActionDown")


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


const STATEMENT = preload("res://Components/SocietyUI/statement.tscn")


func _on_control_society_focused(action: SocietyAction) -> void:
	var active_soc = State.societies[action.parent_society]
	$SocietyName.text = active_soc.archetype.title
	$Icon.texture = active_soc.archetype.star_sign

	$Icon.modulate = active_soc.colors.colors[0]
	$Diag1.color = active_soc.colors.colors[1]
	$Diag2.color = active_soc.colors.colors[2]
	$SocietyName.modulate = active_soc.colors.colors[3]

	for old_component in $Action.get_children():
		old_component.queue_free()

	for component: SocietyActionComponent in action.components:
		var new_statement = STATEMENT.instantiate()
		new_statement.action = component.text
		new_statement.title = component.spresource.title
		$Action.add_child(new_statement)

		# print(component.statement)
