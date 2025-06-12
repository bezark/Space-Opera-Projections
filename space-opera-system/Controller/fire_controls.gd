extends HFlowContainer

@onready var fire: ColorRect = $"../../Fire"

func _on_fire_toggled(toggled_on: bool) -> void:
	visible = toggled_on
	fire.visible = toggled_on


func _on_h_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_h_slider_2_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_color_picker_button_color_changed(color: Color) -> void:
	pass # Replace with function body.


func _on_color_picker_button_2_color_changed(color: Color) -> void:
	pass # Replace with function body.
