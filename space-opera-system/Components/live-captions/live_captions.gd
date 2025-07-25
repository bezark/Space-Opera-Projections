extends Node

signal words_spoken(words: String)
#@onready var stt_label: Label = $STTLabel

var _process_io: FileAccess
var _thread: Thread
var dbus_pid = null


func _ready() -> void:
	#if not Engine.is_editor_hint():
	# Start dbus-monitor asynchronously, capture stdin/stdout pipe
	var proc_info = (
		OS
		. execute_with_pipe(
			"bash",
			[
				"-c",
				"dbus-monitor \"type='signal',interface='net.sapples.LiveCaptions.External',path='/net/sapples/LiveCaptions/External',member='TextStream'\""
			],
			false
		)
	)
	_process_io = proc_info["stdio"]
	dbus_pid = proc_info["pid"]
	print(dbus_pid)

	# Spawn a thread to read lines as they arrive
	_thread = Thread.new()
	_thread.start(_read_dbus_stream, Thread.PRIORITY_HIGH)


func _read_dbus_stream() -> void:
	while _process_io.is_open():# and _process_io.get_error() == OK:
		#print('goo')
		var line = _process_io.get_line()
		if line != "":
			#print(line)
			# Dispatch back to main thread for any Godot‑API work
			#line = line.split("string \"")

			var s = line.strip_edges()
			if s.begins_with("string"):
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
	words_spoken.emit(words)
	#print(words)
	#stt_label.text = words


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		print("killin")
		OS.kill(dbus_pid)
		dbus_pid = null


func _on_tree_exiting() -> void:
	OS.kill(dbus_pid)
