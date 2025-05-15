extends Node
class_name GameState

@export var active_phase: Phase
@export var phases: Dictionary[String, Phase]

@export var societies: Dictionary[String, Society]
@export var communities: Dictionary[String, Community]
@export var resources: Dictionary[String, SPResource]


func save():
	# print("---------------------")
	var current_session = SessionData.new()
	current_session.active_phase = active_phase
	current_session.phases = phases
	current_session.societies = societies
	# ResourceSaver.save(current_session, "res://test_session.tres")
	ResourceSaver.save(current_session, "res://GAME_STATE.tres")


func load_state():
	var current_session: SessionData = ResourceLoader.load("res://GAME_STATE.tres")
	active_phase = current_session.active_phase
	phases = current_session.phases
	societies = current_session.societies
	resources = current_session.resources


func _ready() -> void:
	load_state()
