extends HFlowContainer
@onready var orbital_camera: OrbitalCamera = $"../.."

var pois: Array[Node]


func make_poi_buttons():
	for point in pois:
		var new_poi_button = Button.new()
		new_poi_button.text
