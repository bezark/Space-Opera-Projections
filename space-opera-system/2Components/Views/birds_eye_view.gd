extends Control

@export var Societies: Array[Society]
const SOCIETY_SHEET = preload("res://2Components/Views/society_sheet.tscn")

func _ready():
	for society : Society in Societies:
		var society_view = SOCIETY_SHEET.instantiate()
		society_view.society = society
		$MarginContainer/SocietyContainer.add_child(society_view)
