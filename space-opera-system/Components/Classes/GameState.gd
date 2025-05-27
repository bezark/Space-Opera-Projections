extends Node
class_name GameState

@export var active_phase: Phase
@export var phases: Array[Phase]

@export var societies: Dictionary[String, Society]
@export var communities: Dictionary[String, Community]
@export var resources: Dictionary[String, SPResource]

@export var archetypes : Dictionary[String,Archetype]

func save():
	# print("---------------------")
	var current_session = SessionData.new()
	current_session.active_phase = active_phase
	current_session.phases = phases
	current_session.societies = societies
	current_session.resources = resources
	#TODO: remove this unnecessary save
	current_session.archetypes = archetypes
	# ResourceSaver.save(current_session, "res://test_session.tres")
	ResourceSaver.save(current_session, "res://Data/GAME_STATE.tres")
	print('Saved')


func load_state():
	var current_session: SessionData = ResourceLoader.load("res://Data/GAME_STATE.tres")
	active_phase = current_session.active_phase
	phases = current_session.phases
	societies = current_session.societies
	resources = current_session.resources
	archetypes = current_session.archetypes


func _ready() -> void:
	load_state()
