extends Button
class_name  POIButton

var poi : CelestialBody

signal poi_selected(poi: CelestialBody)


func _ready() -> void:
	pressed.connect(button_just_pressed)


func button_just_pressed():
	poi_selected.emit(poi)
