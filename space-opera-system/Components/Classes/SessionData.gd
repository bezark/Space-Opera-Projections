extends Resource
class_name SessionData

# @export var current_state : GameState

@export var active_phase: Phase

@export var phases: Array[Phase]

@export var societies: Dictionary[String, Society]
@export var communities: Dictionary[String, Community]
@export var resources: Dictionary[String, SPResource]
@export var archetypes: Dictionary[String,Archetype]
@export var actions_queued: Array[SocietyAction]
@export var projecct_resources = 0
