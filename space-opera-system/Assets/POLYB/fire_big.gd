extends Node3D

var emitting = false :
	set(val):
		emitting = val
		$Flame.emitting = emitting
		$Smoke.emitting = emitting
		$Sparks.emitting = emitting
