extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _input(event):
	print(event)
	if event== InputEventScreenDrag:
		print(event)


func _on_button_pressed():
	print('wwwww') # Replace with function body.
