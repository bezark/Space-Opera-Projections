extends Node

signal phase_changed
@export var state: GameState


func _on_fetch_game_data_game_fetched(game):
	if game:
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

		if new_phase.type != state.active_phase.type or !state.active_phase:
			phase_changed.emit(new_phase)
			print("Phase changed!")
		state.active_phase = new_phase
		state.active_phase.id = "dog"
		State.state = state

		# print(game.societies)
		#ResourceSaver.save(state, "res://Data/game_state.tres")
