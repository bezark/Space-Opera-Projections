extends PanelContainer

class_name SocietySheet
@export var society : Society

@onready var communities = $VBox/Communities
const COMMUNITY_SHEET = preload("res://2Components/Views/community_sheet.tscn")
func _ready():
	$VBox/Name.text = society.title
	for community in society.communities:
		var new_community_sheet = COMMUNITY_SHEET.instantiate()
		new_community_sheet.community = community
		$VBox/Communities.add_child(new_community_sheet)
		
