extends Button
class_name SocietyButton

var society: Society

signal society_selected(soc: Society)


func _ready() -> void:
	text = society.title
	pressed.connect(button_just_pressed)


func button_just_pressed():
	society_selected.emit(society)
