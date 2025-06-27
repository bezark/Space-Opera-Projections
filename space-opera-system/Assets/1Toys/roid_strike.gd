extends Path3D

@onready var roid: MeshInstance3D = $Roid
@export var speed = 0.005
var moving = false
func strike():
	$PathFollow3D/Roid.show()
	$PathFollow3D.progress_ratio = 1.
	moving = true
	
func _process(delta: float) -> void:
	if moving:
		$PathFollow3D.progress_ratio  -= speed
		print($PathFollow3D.progress_ratio)
		if $PathFollow3D.progress_ratio <= 0:
			moving = false
			$PathFollow3D/Roid/BlueSplosion.emitting =true

func _on_blue_splosion_finished() -> void:
	$PathFollow3D/Roid/BlueSplosion.emitting =false
	$PathFollow3D/Roid.hide()
