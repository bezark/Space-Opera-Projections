extends Node

signal phase_changed
# @export var phases: Array[Phase]
@export var state: GameState


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fetch_game_data_game_fetched(game):
	for phase in game.phases:
		var new_phase = Phase.new()
		new_phase.id = phase.id
		new_phase.type = phase.type
		new_phase.status = phase.status
		new_phase.round = phase.round
		new_phase.duration = phase.duration
		new_phase.timeElapsed = phase.timeElapsed
		state.phases[phase.id] = new_phase

		if new_phase.status == "playing":
			if new_phase.id != state.active_phase.id or !state.active_phase:
				print("Phase changed!")
				state.active_phase = new_phase
				phase_changed.emit(state.active_phase)
				
			
	ResourceSaver.save(state, "res://Data/game_state.tres")
