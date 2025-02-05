extends PanelContainer
class_name CommunitySheet

@export var community : Community
@onready var title = $VBox/Title
@onready var resources = $VBox/Resources

const EDITABLE_RESOURCE = preload("res://2Components/Views/EditableResource.tscn")

func _ready():
	
	populate()

func populate():
	for child in resources.get_children():
		child.queue_free()
	title.text = community.title
	for resource : SPResource in community.resources:
		var editable_resource = EDITABLE_RESOURCE.instantiate()
		editable_resource.resource = resource
		resources.add_child(editable_resource)
