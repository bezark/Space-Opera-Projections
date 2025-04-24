extends Node3D

var current_society :  Society :
	set(value):
		current_society = value
		$Society/Title.text = current_society.title

func _ready() -> void:
	print(State.societies)

var index = 0
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		var skeys = State.societies.keys()
		index += 1
		index %= skeys.size()
		current_society = State.societies[skeys[index]]
