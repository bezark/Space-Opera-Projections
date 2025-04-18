extends Resource
class_name SessionData

# @export var current_state : GameState

@export var active_phase: Phase
@export var phases: Dictionary[String, Phase]

@export var societies: Array[Society]
