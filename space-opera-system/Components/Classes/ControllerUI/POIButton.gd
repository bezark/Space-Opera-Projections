extends Button
class_name  POIButton

var poi : Node3D

signal poi_selected(poi: Node3D)


func _ready() -> void:
	pressed.connect(button_just_pressed)


func button_just_pressed():
	poi_selected.emit(poi)
