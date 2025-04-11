extends Node

var phases = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fetch_game_data_game_fetched(game):
	phases = game.phases
	for phase in phases:
		
		if phase.status == "playing":
			print(phase)
			#or phase.status == "paused"
