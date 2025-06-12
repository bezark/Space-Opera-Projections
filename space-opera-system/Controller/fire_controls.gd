extends HFlowContainer

@onready var fire: ColorRect = $"../Fire"


func _on_fire_toggled(toggled_on: bool) -> void:
	visible = toggled_on
	fire.visible = toggled_on
	$HSlider.value=0.

func _on_h_slider_value_changed(value: float) -> void:
	fire.material.set("shader_parameter/fire_alpha", value)


func _on_h_slider_2_value_changed(value: float) -> void:
	fire.material.set("shader_parameter/vignette_radius", value)


func _on_color_picker_button_color_changed(color: Color) -> void:
	fire.material.set("shader_parameter/root_color",color)


func _on_color_picker_button_2_color_changed(color: Color) -> void:
	fire.material.set("shader_parameter/tip_color",color)


func _on_h_slider_3_value_changed(value: float) -> void:
	fire.material.set("shader_parameter/fire_speed", Vector2(value,0.5))
