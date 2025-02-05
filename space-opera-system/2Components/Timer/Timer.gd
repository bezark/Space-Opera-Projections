extends HBoxContainer
class_name TimerUI

signal timer_finished
signal timer_reset
signal timer_started
signal timer_ticked

@export var mins: int
@export_range(0., 59., 1.0) var seconds

var total_seconds_left :int = 0
var minutes_left = 0
var seconds_left = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	#timer_start = Time.get_time_dict_from_system()
	reset_timer()
	start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#print(Time.get_unix_time_from_system())


func _on_timer_timeout():
	total_seconds_left -= 1
	minutes_left = total_seconds_left/60
	seconds_left = total_seconds_left%60
	var minutes_left_string : String = "%02d" %minutes_left
	var seconds_left_string : String = "%02d" %seconds_left
	$Minutes.text = minutes_left_string
	$Seconds.text = seconds_left_string
	timer_ticked.emit(str(minutes_left_string, ":", seconds_left_string))
	
	if total_seconds_left <= 0:
		$Timer.start()
		timer_finished.emit()

func reset_timer():
	$Timer.stop()
	total_seconds_left = mins*60 + seconds
	var minutes_left_string : String = "%02d" %mins
	var seconds_left_string : String = "%02d" %seconds
	$Minutes.text = minutes_left_string
	$Seconds.text = seconds_left_string
	timer_ticked.emit(str(minutes_left_string, ":", seconds_left_string))
	timer_reset.emit()

func start_timer():
	$Timer.start()
	timer_started.emit()
	
	

	#prints(minutes_left,seconds_left, total_seconds_left)
	
