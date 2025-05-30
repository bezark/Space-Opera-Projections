extends FlowContainer


func _on_button_toggled(toggled_on: bool) -> void:
	$Controls.visible = toggled_on
