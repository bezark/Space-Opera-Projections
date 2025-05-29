@tool
extends Polygon2D
class_name MappingSurface
@export var title:String


#@export var active_scene : PackedScene


	#var scene_to_load = active_scene.instantiate()
	#$SubViewport.add_child(scene_to_load)

#func scene_change(scene_data: SceneData):
	#var ded_kidz = $SubViewport.get_children()
	#for kid in ded_kidz:
		#kid.queue_free()
		##TODO: add multicamera
	#var scene_to_load = scene_data.scene.instantiate()
	#$SubViewport.add_child(scene_to_load)
