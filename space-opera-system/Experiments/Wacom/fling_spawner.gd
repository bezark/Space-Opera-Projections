extends Node2D

const BOUNCY_BOI = preload("res://Experiments/Wacom/bouncy_boi.tscn")
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_select"):
		var new_boi = BOUNCY_BOI.instantiate()
		$"..".erased.connect(new_boi._on_wacom_testing_erased)
		add_child(new_boi)
		
