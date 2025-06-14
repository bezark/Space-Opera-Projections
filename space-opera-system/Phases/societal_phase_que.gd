extends Control

@onready var text_edit: TextEdit = $HBoxContainer/TextEdit

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("UIUp")
	else:
		$AnimationPlayer.play("UIDown")


func _on_text_edit_text_changed() -> void:
	$SocietyName.text = text_edit.text
