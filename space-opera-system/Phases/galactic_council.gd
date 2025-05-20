extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	%Time.text = State.active_phase.time.remainingFormatted


func _on_dais_controls_society_approached(society: Society) -> void:
	#$TextureRect/MarginContainer/VBoxContainer/Label.text = society.title
	print(society)


func _on_dice_cam_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("dicecam_up")
	else:
		$AnimationPlayer.play("dicecam _down")
