extends SystemCamera

var POIs = []


func _ready():
	POIs = get_tree().get_nodes_in_group("point_of_interest")


func start() -> void:
	
	look_at(Vector3.UP, POIs.pick_random().position)
