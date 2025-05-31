extends Node

signal scene_changed

#@export var oldscenes: Dictionary[String, PackedScene]

@export var structure : SceneStructure
@export var mapping_surfaces :Array[MappingSurface]


func _on_datapad_sync_phase_changed(phase: Phase):
	#TODO: Add animations, round variation

	print(phase.type)
	#scene_changed.emit(structure.scene_data[phase.type])
	


func _on_control_scene_changed(scene: SceneData) -> void:
	print(scene.scene)
	#var ded_kidz = $LIVE.get_children()
	#for kid in ded_kidz:
		#kid.queue_free()
	#var new_scene = scene.scene.instantiate()
	# TODO: rework all of this
	#for surface in mapping_surfaces:
		#surface.texture.viewport_path = new_scene.get(surface.title).get_path()
