extends HFlowContainer
@onready var orbital_camera: OrbitalCamera = $"../.."

var pois: Array[Node]


func make_poi_buttons():
	for ded_kid in get_children():
		ded_kid.queue_free()
	for point in pois:
		var new_poi_button = POIButton.new()
		new_poi_button.poi = point
		new_poi_button.text = point.name
		new_poi_button.poi_selected.connect(poi_selected)
		add_child(new_poi_button)

func poi_selected(poi):
	orbital_camera.focus = poi
	orbital_camera.start()
