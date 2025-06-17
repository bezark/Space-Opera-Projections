extends MeshInstance3D

var speed = 10.
var direction : Vector3

func _ready() -> void:
	speed = randf_range(-0.3, 0.3)
	direction = Vector3(randf_range(-1.,1.0),randf_range(-1.,1.0),randf_range(-1.,1.0))
	
func _process(delta: float) -> void:
		rotation += direction*speed*delta
