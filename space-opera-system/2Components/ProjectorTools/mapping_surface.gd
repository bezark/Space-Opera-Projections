@tool
extends Polygon2D

@export var active_scene : PackedScene

func _ready():
	var scene_to_load = active_scene.instantiate()
	$SubViewport.add_child(scene_to_load)

func scene_change(new_scene: PackedScene):
	var ded_kidz = $SubViewport.get_children()
	for kid in ded_kidz:
		kid.queue_free()
	var scene_to_load = new_scene.instantiate()
	$SubViewport.add_child(scene_to_load)
