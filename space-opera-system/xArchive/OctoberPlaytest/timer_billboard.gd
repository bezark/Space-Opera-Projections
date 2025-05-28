extends Label


func _process(delta):
	if State.active_phase:
		text = State.active_phase.time.remainingFormatted
