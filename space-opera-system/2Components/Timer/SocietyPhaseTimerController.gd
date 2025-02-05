extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Minutes.value = $Timer.mins
	$Seconds.value = $Timer.seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	$Timer.reset_timer()


func _on_start_button_down():
	$Timer.start_timer()


func _on_stop_button_down():
	$Timer/Timer.stop()
	
	

	


func _on_minutes_value_changed(value):
	$Timer.mins = value


func _on_seconds_value_changed(value):
	$Timer.seconds = value
