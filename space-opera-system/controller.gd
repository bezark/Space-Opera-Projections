extends Window


func _ready() -> void:
	get_tree().tree_changed.connect(check_for_controls)

func check_for_controls():
	print(get_tree().root)

func attach(nodes:Node):
	nodes.reparent($MarginContainer)
