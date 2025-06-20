extends Node3D

func _ready() -> void:
	 #prints.call_deferred("effects for ", $"..".body.name)

	#reparent.call_deferred($"..". body, false)
	position = Vector3.ZERO



func _on_zap_toggled(toggled_on: bool) -> void:
	$ElectricExplosion.auto_animate = toggled_on


func _on_boom_toggled(toggled_on: bool) -> void:
	$ExplosionBig.auto_animate = toggled_on
	$FireBig.emitting = toggled_on


func _on_shoot_toggled(toggled_on: bool) -> void:
	$Weapons/Fireballs.visible = toggled_on


func _on_laser_toggled(toggled_on: bool) -> void:
	$Weapons/Laser.visible = toggled_on
