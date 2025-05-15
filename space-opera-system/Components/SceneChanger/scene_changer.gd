extends Node

signal scene_changed

#@export var oldscenes: Dictionary[String, PackedScene]

@export var structure : SceneStructure



func _on_datapad_sync_phase_changed(phase: Phase):
	#TODO: Add animations, round variation

	print(phase.type)
	scene_changed.emit(structure.scene_data[phase.type])
