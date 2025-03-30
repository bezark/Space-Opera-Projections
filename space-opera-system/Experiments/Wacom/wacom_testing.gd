extends Node
signal erased

func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CONFINED_HIDDEN

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#print(event.button_mask, event.pen_inverted, event.pressure, event.tilt) #InputEventMouseMotion: button_mask=0, position=((378.0, 57.0)), relative=((-23.0, -15.0)), velocity=((-4569.772, -2949.853)), pressure=0.00, tilt=((0.0, 0.0)), pen_inverted=(false)
		if event.pen_inverted:
			erased.emit(event)
