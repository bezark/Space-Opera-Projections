extends Node3D

@export var armed: bool
@export var target: CelestialBody:
	set(val):
		target = val
		call_deferred("adjust_beam")

const BLUE_SPLOSION = preload("res://Assets/1Toys/blue_splosion.tscn")
var powering = false


func _process(delta: float) -> void:
	if armed:
		if target.is_inside_tree():
			look_at(target.body.global_position)


func _ready() -> void:
	armed = false
#$AnimationPlayer.play("Arm")


func _on_armed_toggled(toggled_on: bool) -> void:
	armed = toggled_on
	if toggled_on:
		#armed = toggled_on
		# for ring in $Rings.get_children():
		# 	var tween = get_tree().create_tween()
		# 	tween.tween_property(ring, "rotation_degrees", Vector3(0., 90., 90.), 7000)
		# await get_tree().create_timer(7.0).timeout
		$AnimationPlayer.play("Arm")

	else:
		$AnimationPlayer.play("Disarm")


func _on_destroy_pressed() -> void:
	var blu = BLUE_SPLOSION.instantiate()
	blu.finished.connect(destroyed)
	add_child(blu)
	blu.global_position = target.body.global_position
	blu.emitting = true
	armed = false
	target._on_delete_pressed()
	
	
func destroyed():
	$Beam.visible=false
	pass  # Replace with function body.


func _on_power_toggled(toggled_on: bool) -> void:
	powering = toggled_on
	adjust_beam()
	$Beam.visible = toggled_on
	# $Line3D.visible = toggled_on


func adjust_beam():
	var dist = global_position.distance_to(target.body.global_position)
	$Beam.position.z = dist / 2
	$Beam.height = dist


func _on_power_value_changed(value: float) -> void:
	$Beam.radius = value
	# $Beam.material
