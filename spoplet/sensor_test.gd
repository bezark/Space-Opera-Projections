extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Mag.text = str(Input.get_magnetometer())
	$Gyro.text = str(Input.get_gyroscope())
	$Accel.text = str(Input.get_accelerometer())
	$Grav.text = str(Input.get_gravity())

func _input(event):
	if event is InputEventGesture:
		$Gesture.texture = str(event.as_text())
