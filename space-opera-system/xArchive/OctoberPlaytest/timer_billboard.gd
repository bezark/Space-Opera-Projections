extends Label


func _process(delta):
	text = State.active_phase.time.remainingFormatted
