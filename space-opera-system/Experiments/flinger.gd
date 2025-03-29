extends RigidBody2D


func _on_wacom_testing_erased(event : InputEventMouseMotion) -> void:
	linear_velocity+=event.relative*event.pressure
