extends MeshInstance3D

@onready var white: Node3D = $WhiteHole/White
@onready var black: Node3D = $BlackHole/Black
@onready var white_hole_cb: CelestialBody = $WhiteHole
@onready var black_hole_cb: CelestialBody = $BlackHole

@onready var holes: ShaderMaterial = get_active_material(0)


func _process(delta: float) -> void:
	var positions := holes.get_shader_parameter("black_hole_positions") as PackedVector3Array
	positions[0] = white.global_position
	positions[1] = black.global_position
	holes.set_shader_parameter("black_hole_positions", positions)


func _on_less_button_down() -> void:
	white_hole_cb.rate = -1
	black_hole_cb.rate = 1


func _on_less_button_up() -> void:
	white_hole_cb.rate = 0
	black_hole_cb.rate = 0


func _on_more_button_down() -> void:
	white_hole_cb.rate = 1
	black_hole_cb.rate = -1


func _on_more_button_up() -> void:
	white_hole_cb.rate = 0
	black_hole_cb.rate = 0


func _on_speed_value_changed(value: float) -> void:
	white_hole_cb.speed = value
	black_hole_cb.speed = value


func _on_w_scale_value_changed(value: float) -> void:
	var sizes := holes.get_shader_parameter("black_hole_sizes") as PackedFloat32Array
	sizes[0] = value
	holes.set_shader_parameter("black_hole_sizes", sizes)


func _on_b_scale_value_changed(value: float) -> void:
	var sizes := holes.get_shader_parameter("black_hole_sizes") as PackedFloat32Array
	sizes[1] = value
	holes.set_shader_parameter("black_hole_sizes", sizes)
