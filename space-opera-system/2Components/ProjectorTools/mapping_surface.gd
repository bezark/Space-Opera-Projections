@tool
extends Polygon2D
@export var projector = 0 
@export var active_scene : PackedScene

func _ready():
	var scene_to_load = active_scene.instantiate()
	$SubViewport.add_child(scene_to_load)

func scene_change(scene_data: SceneData):
	var ded_kidz = $SubViewport.get_children()
	for kid in ded_kidz:
		kid.queue_free()
		#TODO: Add check for the same scene
	var scene_to_load = scene_data.scenes[projector].instantiate()
	$SubViewport.add_child(scene_to_load)
