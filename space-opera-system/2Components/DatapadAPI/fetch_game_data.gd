extends HTTPRequest

@export var url: String = "localhost:8080"
@export var game_id: String = "u65YG"

signal game_fetched


func _ready() -> void:
	request_completed.connect(self._http_request_completed)


func get_game():
	var req_string = str(url, "/api/v1/episodes/active")
	#print(req_string)
	var error = request(req_string)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	# print(response.name)
	# print(response.societies)
	# print(response.phases)
	game_fetched.emit(response)
