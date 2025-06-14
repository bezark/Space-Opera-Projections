extends HFlowContainer

var title: String
var action: String


func _ready() -> void:
	$Resource.text = title
	$Action.text = action
	var statement = str("We use ",title," to ", action)
	$whole.text = statement
