extends Node3D




var emitting = false :
	set(val):
		emitting = val
		$Flame.emitting = emitting
		$Smoke.emitting = emitting
		$Sparks.emitting = emitting
		$OmniLight3D.visible = emitting

func _ready() -> void:
	emitting = false
