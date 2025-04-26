extends Node3D
const RESOURCE_PROP = preload("res://Experiments/PropTemplates/ResourceProp.tscn")
var title : String
var resources: Dictionary[String, SPResource]
var model :PackedScene
func _ready() -> void:
	if model:
		add_child(model.instantiate())
	$Title.text = title
	
	var keys = resources.keys()
	for key in keys:
		var new_resource = RESOURCE_PROP.instantiate()
		new_resource.model = resources[key].model
		new_resource.title = resources[key].title
		print(new_resource.title)
		new_resource.position.x = randf_range(-3.0, 3.0)
		add_child(new_resource)
