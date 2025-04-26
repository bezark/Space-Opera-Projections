extends Node3D

var title : String

var model :PackedScene
func _ready() -> void:
	if model:
		add_child(model.instantiate())
	if title:
		$Title.text = title
