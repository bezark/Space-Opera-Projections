extends Node

signal words_spoken(words: String)
@onready var stt_label: Label = $STTLabel

var _process_io : FileAccess
var _thread     : Thread

func _ready() -> void:
	# Start dbus-monitor asynchronously, capture stdin/stdout pipe
	var proc_info = OS.execute_with_pipe(
		"bash",
		["-c", "dbus-monitor \"type='signal',interface='net.sapples.LiveCaptions.External',path='/net/sapples/LiveCaptions/External',member='TextStream'\""]
	)
	_process_io = proc_info["stdio"]
	# Spawn a thread to read lines as they arrive
	_thread = Thread.new()
	_thread.start(_read_dbus_stream, Thread.PRIORITY_HIGH)

func _read_dbus_stream() -> void:
	while _process_io.is_open() and _process_io.get_error() == OK:
		var line = _process_io.get_line()
		if line != "":
			print(line)
			# Dispatch back to main thread for any Godot‑API work
			#line = line.split("string \"")
			
			var s = line.strip_edges()
			if s.begins_with("string"):
		# s == e.g. `string "So I want to parse this entire de"`
				var parts = s.split('"')
				if parts.size() >= 2:
					var message = parts[1]
					call_thread_safe("new_words", message)

			#var linearr:  Array = line.split("\"")
			#if linearr.size()>1 :
				#if linearr[1].length():
					#call_thread_safe("new_words", linearr[1])
			#print(linearr)
	return


func new_words(words):
	stt_label.text = words
