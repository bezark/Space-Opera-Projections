extends HBoxContainer
signal message_broadcasted



func _on_button_button_down():
	message_broadcasted.emit($Message.text)
