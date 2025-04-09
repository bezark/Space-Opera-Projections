extends Label


func _on_timer_timer_ticked(time):
	text = time


func _on_billboard_broadcast_message_broadcasted(message):
	text = message
