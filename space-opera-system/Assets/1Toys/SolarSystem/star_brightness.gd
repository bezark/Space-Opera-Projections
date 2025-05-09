extends HSlider

@export var affected : Node
@export var prop :String
var property
func _ready() -> void:
	connect("value_changed", Callable(self, "_on_value_changed"))
	Controller.call_deferred("attach",self)
	#property = ???

@onready var star: CSGSphere3D = %Star

func _on_value_changed(value: float) -> void:
	set_by_string(affected,prop,value)
	#star.material.emission_energy_multiplier=value

func set_by_string(root: Object, path: String, value) -> void:
	var parts = path.split(".")
	var last = parts.la()
	var current: Object = root
	for key in parts:
		current = current.get(key)
		if current == null:
			push_error("set_by_string: couldn’t follow “%s” on null" % key)
			return
	current.set(last, value)
