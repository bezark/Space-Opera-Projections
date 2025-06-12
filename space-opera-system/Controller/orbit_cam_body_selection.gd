extends HFlowContainer
@onready var orbital_camera: OrbitalCamera = $"../.."
@onready var controller: Control = $"../../../../../../Control"

var pois: Array[Node]


func _ready() -> void:
	State.celestial_body_deleted.connect(_on_control_controls_updated)
	State.celestial_body_focused.connect(poi_selected)


# func make_poi_buttons():
# 	for ded_kid in get_children():
# 		ded_kid.queue_free()
# 	for point in pois:
# 		var new_poi_button = POIButton.new()
# 		new_poi_button.poi = point
# 		new_poi_button.text = point.body.name
# 		new_poi_button.poi_selected.connect(poi_selected)
# 		add_child(new_poi_button)


func poi_selected(poi: CelestialBody):
	orbital_camera.focus = poi
	print("tryiiing to zoom")
	controller.make_zoom_buttons(poi.scene_data)
	orbital_camera.start()


func _on_control_controls_updated() -> void:
	orbital_camera._ready()
