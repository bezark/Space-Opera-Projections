extends CSGTorus3D

@export var speed = 5.

func _process(delta: float) -> void:
	rotate_y(speed)
