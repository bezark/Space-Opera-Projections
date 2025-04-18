extends Node

signal phase_changed


func _on_timer_timeout() -> void:
	$FetchGameData.get_game()


func _on_fetch_game_data_game_fetched(game) -> void:
	$Timer.start()
	if game:
		### PHASE ###
		var phase = game.currentPhase
		var new_phase = Phase.new()
		# new_phase.id = phase.id

		new_phase.type = phase.type
		new_phase.status = phase.status
		new_phase.round = phase.round

		new_phase.time.duration = phase.time.duration
		new_phase.time.elapsed = phase.time.elapsed
		new_phase.time.remaining = phase.time.remaining
		new_phase.time.remainingFormatted = phase.time.remainingFormatted

		# 	state.phases[phase.id] = new_phase

		if !State.active_phase:
			phase_changed.emit(new_phase)

		elif new_phase.type != State.active_phase.type:
			phase_changed.emit(new_phase)
		State.active_phase = new_phase

	### SOCIETIES ###

	print(game.societies)

	for society in game.societies:
		print(society.name)
		for community in society.communities:
			print(community.name)
		pass

	State.save()
