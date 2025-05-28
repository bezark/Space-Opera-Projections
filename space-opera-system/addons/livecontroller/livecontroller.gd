@tool
extends EditorPlugin

var server := TCPServer.new()

func _enter_tree():
	server.listen(7878)
	set_process(true)

func _process(_delta):
	while server.is_connection_available():
		var client = server.take_connection()
		client.poll()
		var msg = client.get_var()
		print(msg)
		get_editor_interface().open_scene_from_path(msg)
		client.disconnect_from_host()



	
#var signal_connected = false
#
#func _enter_tree() -> void:
	## Initialization of the plugin goes here.
	#pass
	#add_autoload_singleton("SceneOpen", "res://addons/livecontroller/scene_open.gd")
	#
#func _ready() -> void:
	#print('setting up livecontroller')
	#
#func _process(delta: float) -> void:
	#
	##print('yoo')
	#if not Engine.is_editor_hint() and not signal_connected:
		#print('connecting sceneopen')
		#SceneOpen.scene_opened.connect(switch_scene)
		#signal_connected = true
	#elif Engine.is_editor_hint() and signal_connected:
		#print('disconnecting sceneopen')
		#signal_connected = false
	#
