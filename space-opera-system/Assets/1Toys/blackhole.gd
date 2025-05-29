extends MeshInstance3D

class_name Blackhole


func _on_scale_value_changed(value: float) -> void:
	
	var hole:ShaderMaterial = get_active_material(0)
	hole.set_shader_parameter("scale", value)
	
#"shader_parameter/scale"
