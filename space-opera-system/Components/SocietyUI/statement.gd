extends RichTextLabel

var title: String
var action: String


func _ready() -> void:
	var statement = str("We use [b]",title,"[/b] to ", action)
	text = statement
