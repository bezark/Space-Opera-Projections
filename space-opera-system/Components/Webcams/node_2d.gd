extends Node2D

var camera_feed: CameraFeed
var camera_texture: CameraTexture

@onready var sprite: Sprite2D = $Sprite2D

# Hardcoded device name and format
@export var DEVICE_NAME = "Logitech BRIO"  # Replace with your camera's name
@export var FORMAT_INDEX = 114  # Use the first available format


func _ready():
	# Find the camera feed with the specified name
	for feed in CameraServer.feeds():
		if feed.get_name() == DEVICE_NAME:
			camera_feed = feed
			break

	if camera_feed:
		# Set up the camera texture
		camera_texture = CameraTexture.new()
		camera_texture.set_camera_feed_id(camera_feed.get_id())

		# Create a sprite to display the camera texture

		sprite.texture = camera_texture

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
