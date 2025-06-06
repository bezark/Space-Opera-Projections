extends SubViewport


func _on_control_zoomed_in(zoom: PackedScene) -> void:
	for ded_kid in $Zoom.get_children():
		ded_kid.queue_free()
	var new_zoom = zoom.instantiate()
	$Zoom.add_child(new_zoom)

#FIXME: MOVE  this lol
func _on_control_view_fade_adjusted(val: float) -> void:
	$"../Circle/Zoom".modulate = Color(1.,1.,1., val)
