extends VBoxContainer

@export var resource : SPResource
@onready var title = $Title
@onready var relationship = $Relationship

func _ready():
	if resource:
		title.text = resource.title
		relationship.text = resource.relationship
