extends Node3D

const COMMUNITY_PROP = preload("res://Experiments/PropTemplates/CommunityProp.tscn")

var current_society :  Society :
	set(value):
		current_society = value
		$SocietyTitle.text = current_society.title
		
		var ded_kidz = $Society.get_children()
		for dk in ded_kidz:
			dk.queue_free()
		if current_society.model:
			$Society.add_child(current_society.model.instantiate())
		for key in current_society.communities:
			var new_community = COMMUNITY_PROP.instantiate()
			new_community.model = current_society.communities[key].model
			new_community.title = current_society.communities[key].title
			new_community.resources = current_society.communities[key].resources
			$Society.add_child(new_community)
			new_community.position.x = randf_range(-3.0, 3.0)

func _ready() -> void:
	print(State.societies)

var index = 0
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		var skeys = State.societies.keys()
		index += 1
		index %= skeys.size()
		current_society = State.societies[skeys[index]]
