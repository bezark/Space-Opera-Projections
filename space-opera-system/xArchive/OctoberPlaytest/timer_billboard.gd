extends Label


func _process(delta):
	text = State.state.active_phase.time.remainingFormatted
