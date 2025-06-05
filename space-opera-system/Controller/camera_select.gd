extends HBoxContainer

@export var cameras: Array[Camera3D]


func _ready() -> void:
	var cam_group = ButtonGroup.new()
	for cam in cameras:
		var new_button = Button.new()
		new_button.button_group = cam_group
		new_button.text = cam.name
		new_button.toggle_mode = true
		new_button.pressed.connect(camera_selected.bind(cam))
		add_child(new_button)


func camera_selected(cam: Camera3D):
	
	for camera in cameras:
		camera.process_mode = Node.PROCESS_MODE_DISABLED
		camera.current = false
	cam.current = true
	cam.process_mode = Node.PROCESS_MODE_INHERIT
	if cam.has_method("start"):
		cam.start()
