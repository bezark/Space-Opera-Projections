extends MeshInstance3D

@onready var white: Node3D = $WhiteHole/White
@onready var black: Node3D = $BlackHole/Black


func _process(delta: float) -> void:
	var holes:ShaderMaterial = get_active_material(0)
	var positions := holes.get_shader_parameter("black_hole_positions") as PackedVector3Array
	positions[0] = black.global_position
	positions[1] = white.global_position
	holes.set_shader_parameter("black_hole_positions", positions)
	
	
