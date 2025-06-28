extends MeshInstance3D

@export var scalar = 1.
@onready var white: Node3D = $WhiteHole/White
@onready var black: Node3D = $BlackHole/Black
@onready var white_hole_cb: CelestialBody = $WhiteHole
@onready var black_hole_cb: CelestialBody = $BlackHole

@onready var holes: ShaderMaterial = get_active_material(0)

var wrate = 0.
var brate = 0.


func _physics_process(delta: float) -> void:
	var positions := holes.get_shader_parameter("black_hole_positions") as PackedVector3Array
	positions[0] = white.global_position
	positions[1] = black.global_position
	holes.set_shader_parameter("black_hole_positions", positions)
	if wrate:
		var sizes := holes.get_shader_parameter("black_hole_sizes") as PackedFloat32Array
		sizes[0] += wrate
		holes.set_shader_parameter("black_hole_sizes", sizes)
		$WhiteHole/White/Disk.mesh.outer_radius += wrate
		#$WhiteHole/White/Disk.mesh.outer_radius = $WhiteHole/White/Disk.mesh.inner_radius*1.5
		#$WhiteHole/White/Star.radius += wrate
		#if $WhiteHole/White/Star.radius <= 1:
			#$WhiteHole/White/Star.hide()
		#else:
			#$WhiteHole/White/Star.show()
	if brate:
		var sizes := holes.get_shader_parameter("black_hole_sizes") as PackedFloat32Array
		sizes[1] += brate

		$BlackHole/Black/Disk.mesh.outer_radius += brate
		$BlackHole/Black/Disk.mesh.inner_radius = $BlackHole/Black/Disk.mesh.outer_radius*0.5

		holes.set_shader_parameter("black_hole_sizes", sizes)


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
	holes.set_shader_parameter.call_deferred("black_hole_sizes", sizes)
	$WhiteHole/White/Disk.inner_radius = value
	$WhiteHole/White/Disk.outer_radius = value * 1.25



func _on_b_scale_value_changed(value: float) -> void:
	var sizes := holes.get_shader_parameter("black_hole_sizes") as PackedFloat32Array
	sizes[1] = value

	$BlackHole/Black/Disk.inner_radius = value
	$BlackHole/Black/Disk.outer_radius = value * 1.25


	holes.set_shader_parameter("black_hole_sizes", sizes)


func _on_w_less_button_down() -> void:
	wrate = -scalar


func _on_w_less_button_up() -> void:
	wrate = 0


func _on_w_right_button_down() -> void:
	wrate = scalar


func _on_w_right_button_up() -> void:
	wrate = 0


func _on_b_less_button_down() -> void:
	brate = -scalar


func _on_b_less_button_up() -> void:
	brate = 0

var split = false
func _on_b_right_button_down() -> void:
	if not split:
		$WhiteHole/White/Disk.mesh.outer_radius = 20
		$WhiteHole/White/Disk.mesh.inner_radius = 10
		$BlackHole/Black/Hole.hide()
		split=true
	brate = scalar


func _on_b_right_button_up() -> void:
	brate = 0


func _on_star_toggled(toggled_on: bool) -> void:
	$FinalStar.visible = toggled_on


func _on_quasar_toggled(toggled_on: bool) -> void:
	$BlackHole/Black/Disk/Quasar.visible = toggled_on

@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"

func _on_heat_value_changed(value: float) -> void:
	world_environment.environment.adjustment_brightness = value
