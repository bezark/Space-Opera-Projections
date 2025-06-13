@tool
extends Node

var camera_feed: CameraFeed

# Hardcoded device name and format
@export var DEVICE_NAME = "Game Capture HD60 S+:Game Capt"  # Replace with your camera's name
@export var FORMAT_INDEX = 114  # Use the first available format
@export var camera_texture: CameraTexture

func _ready():
	# Find the camera feed with the specified name

	for feed in CameraServer.feeds():
		if feed.get_name() == DEVICE_NAME:
			camera_feed = feed
			break
	
	if camera_feed:
		camera_feed.set_active(false)
		
		# Set up the camera texture
		#camera_texture = CameraTexture.new()
		camera_texture.set_camera_feed_id(camera_feed.get_id())
		
		# Create a sprite to display the camera texture
		
		#sprite.texture = camera_texture
		
		
		# Set the format and activate the feed
		if camera_feed.get_formats().size() > FORMAT_INDEX:
			var parameters = {}  # You can add parameters here if needed
			camera_feed.set_format(FORMAT_INDEX, parameters)
		camera_feed.set_active(true)
	else:
		print("Camera not found: ", DEVICE_NAME)

func _exit_tree():
	if camera_feed:
		camera_feed.set_active(false)
