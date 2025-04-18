extends Node

signal scene_changed

@export var scenes: Dictionary[String, PackedScene]


func _on_datapad_sync_phase_changed(phase: Phase):
	#TODO: Add animations, round variation

	print(phase.type)
	scene_changed.emit(scenes[phase.type])
