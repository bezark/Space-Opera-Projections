extends HFlowContainer

var title: String
var action: String


func _ready() -> void:
	$Resource.text = title
	$Action.text = action
