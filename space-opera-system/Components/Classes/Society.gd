extends Resource
class_name Society

@export var title: String
@export var communities: Dictionary[String,Community]
var id: String

@export var planet: PackedScene
@export var colors: ColorPalette
@export var archetype: Archetype
@export var actions: Array[SocietyAction]
