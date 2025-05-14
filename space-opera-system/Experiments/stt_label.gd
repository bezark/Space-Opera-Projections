extends Label


func _on_live_captions_words_spoken(words: String) -> void:
	print(words)
	text = words
