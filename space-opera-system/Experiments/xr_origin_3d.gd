extends XROrigin3D


var xr_interface: XRInterface
#@onready var world_environment: WorldEnvironment = $WorldEnvironment


func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")

	#Uncomment for passthrough
	#get_viewport().transparent_bg = true
	#world_environment.environment.background_mode = Environment.BG_COLOR
	#world_environment.environment.background_color = Color(0.0, 0.0, 0.0, 0.0)
	#xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
