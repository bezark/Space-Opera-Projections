extends FlowContainer

signal society_approached(society: Society)


func _ready() -> void:
	var societies = State.societies
	for society_key in societies:
		print(societies[society_key].title)
		var button = SocietyButton.new()
		button.society = societies[society_key]
		button.society_selected.connect(society_selected)
		add_child(button)


func society_selected(society: Society):
	print(society.title)
	society_approached.emit(society)
