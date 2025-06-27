extends HBoxContainer


func _on_sub_button_down() -> void:
	State.project_resources -= 1
	$Amount.text = str(State.project_resources)

func _on_add_pressed() -> void:
	State.project_resources += 1
	$Amount.text = str(State.project_resources)
