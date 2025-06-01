extends Label
class_name TimeLabel

func _process(delta):
	if State.active_phase:
		text = State.active_phase.time.remainingFormatted
