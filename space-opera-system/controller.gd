extends Window


func _ready() -> void:
	get_tree().tree_changed.connect(check_for_controls)


func check_for_controls():
	var new_controls = get_tree().get_nodes_in_group("controller")
	for nc in new_controls:
		nc.call_deferred("reparent", self)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#TODO: add a check!!!
		get_tree().quit()
