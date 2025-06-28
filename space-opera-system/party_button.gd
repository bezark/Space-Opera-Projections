extends Button

@onready var gpu_particles_3d: GPUParticles3D = $"../../GPUParticles3D"

func _on_toggled(toggled_on: bool) -> void:
	gpu_particles_3d.emitting = toggled_on
