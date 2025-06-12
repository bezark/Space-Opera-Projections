extends Label
class_name TimeLabel

func _process(delta):
	if State.active_phase:
		text = State.active_phase.time.remainingFormatted


func _on_timer_button_toggled(toggled_on: bool) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1.,1.,1., toggled_on), 1)
