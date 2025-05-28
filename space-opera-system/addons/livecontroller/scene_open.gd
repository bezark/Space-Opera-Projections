extends Node
class_name SceneOpener

signal scene_opened(path)


func switch_scene(path):
	#print(path)
	scene_opened.emit(path)
