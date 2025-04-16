extends Node3D

@onready var aether = preload("res://Assets/1Toys/PoweredUp.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(0.001)
	if Input.is_action_pressed("ui_up"):
		aether.emission_energy_multiplier+= 0.01
	if Input.is_action_pressed("ui_down"):
		aether.emission_energy_multiplier-= 0.01
		
		
