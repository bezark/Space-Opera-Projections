extends Node
class_name GameState

@export var active_phase: Phase
@export var phases: Array[Phase]

@export var societies: Dictionary[String, Society]
@export var communities: Dictionary[String, Community]
@export var resources: Dictionary[String, SPResource]

@export var archetypes: Dictionary[String,Archetype]
@export var actions_queued: Array[SocietyAction]

@export var project_resources = 0:
	set(val):
		project_resources  = val
		project_resources_changed.emit(project_resources)
signal project_resources_changed(amount:int)
signal celestial_body_deleted
signal celestial_body_focused(body: CelestialBody)
signal zoomed_in(val:bool)


func save():
	# print("---------------------")
	var current_session = SessionData.new()
	current_session.active_phase = active_phase
	current_session.phases = phases
	current_session.societies = societies
	current_session.resources = resources
	current_session.projecct_resources = project_resources
	#TODO: remove this unnecessary save
	current_session.archetypes = archetypes
	current_session.actions_queued = actions_queued
	# ResourceSaver.save(current_session, "res://test_session.tres")
	ResourceSaver.save(current_session, "res://Data/GAME_STATE.tres")
	print("Saved")


func load_state():
	var current_session: SessionData = ResourceLoader.load("res://Data/GAME_STATE.tres")
	active_phase = current_session.active_phase
	phases = current_session.phases
	societies = current_session.societies
	resources = current_session.resources
	archetypes = current_session.archetypes
	actions_queued = current_session.actions_queued
	project_resources = current_session.projecct_resources

func _ready() -> void:
	load_state()
