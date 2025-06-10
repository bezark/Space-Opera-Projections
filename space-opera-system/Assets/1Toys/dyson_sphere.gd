extends Node3D

@export var armed: bool
@export var target: Node3D


func _process(delta: float) -> void:
	if armed:
		look_at(target.global_position)


func _ready() -> void:
	$AnimationPlayer.play("Arm")
