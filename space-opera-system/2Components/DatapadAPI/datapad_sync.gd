extends Node


func _on_timer_timeout() -> void:
	$FetchGameData.get_game()


func _on_fetch_game_data_game_fetched(game) -> void:
	$Timer.start()
	pass
