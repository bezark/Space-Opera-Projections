extends Node
class_name GameState

@export var active_phase: Phase
@export var phases: Dictionary[String, Phase]

@export var societies: Array[Society]


func save():
	var current_session = SessionData.new()
	current_session.active_phase = active_phase
	current_session.phases = phases
	current_session.societies = societies
	ResourceSaver.save(current_session, "res://test_session.tres")
