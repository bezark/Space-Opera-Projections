extends SubViewport


func _on_control_view_fade_adjusted(val: float) -> void:
	$Zoom.modulate = Color(1.,1.,1., val)
