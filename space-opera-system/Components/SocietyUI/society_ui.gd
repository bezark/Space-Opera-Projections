extends Control

var action_on_deck: SocietyAction

func _ready() -> void:
	State.project_resources_changed.connect(update_project)


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


func _on_control_next_society_pressed(action: SocietyAction) -> void:
	action_on_deck = action
	$AnimationPlayer.play("NextSociety")


func _on_control_prev_society_pressed(action: SocietyAction) -> void:
	action_on_deck = action
	$AnimationPlayer.play("PrevSociety")


func _on_control_society_complete_pressed() -> void:
	pass  # Replace with function body.


func _on_control_ui_toggeled(shown: bool) -> void:
	if shown:
		$AnimationPlayer.play("UIUp")
		visible = shown
	else:
		$AnimationPlayer.play("UIDown")


const STATEMENT = preload("res://Components/SocietyUI/statement.tscn")


func _on_control_society_focused(action: SocietyAction) -> void:
	var active_soc:Society = State.societies[action.parent_society]
	$The/SocietyName.text = active_soc.archetype.title
	$Icon.texture = active_soc.archetype.star_sign

	$Icon.modulate = active_soc.colors.colors[0]
	$Diag1.color = active_soc.colors.colors[1]
	$Diag2.color = active_soc.colors.colors[2]
	$The.modulate = active_soc.colors.colors[3]

	for old_component in $Action.get_children():
		if not old_component.is_in_group("permanent"):
			old_component.queue_free()

	for component: SocietyActionComponent in action.components:
		var new_statement = STATEMENT.instantiate()
		new_statement.action = component.text
		new_statement.title = component.spresource.title
		$Action.add_child(new_statement)

		# print(component.statement)
	if active_soc.turn.advantage != 0:
		$Modifiers/Advantage.show()
	else:
		$Modifiers/Advantage.hide()
	if active_soc.turn.disadvantage != 0:
		$Modifiers/Disadvantage.show()
	else:
		$Modifiers/Disadvantage.hide()
	$Modifiers/Advantage/Digit.text = str(active_soc.turn.advantage)
	$Modifiers/Disadvantage/Digit.text = str(active_soc.turn.disadvantage)
	$Risk/Digit.text = str(active_soc.turn.risk)
func swap_society():
	_on_control_society_focused(action_on_deck)


func _on_control_gen_dc_up() -> void:
	$AnimationPlayer.play("generations")


func _on_control_mods_toggled(visible: bool) -> void:
	if visible:
		$AnimationPlayer.play("AdvUp")
	else:
		$AnimationPlayer.play("AdvDown")


func _on_control_risk_toggled(visible: bool) -> void:
	if visible:
		$AnimationPlayer.play("RiskUp")
	else:
		$AnimationPlayer.play("RiskDown")


func _on_control_refresh_ui() -> void:
	_on_control_society_focused(action_on_deck)


func _on_control_project_toggled(visible: bool) -> void:
	if visible:
		$AnimationPlayer.play("ProjectUp")
	else:
		$AnimationPlayer.play("ProjectDown")
		
func update_project(amount):
	$Project/Digit.text = str(amount)
