extends HTTPRequest

@export var url: String = "http://datapad.dainsaint.com"
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


var previous_state = {}


func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	if json.get_data():
		var response: Dictionary = json.get_data()
	# print(response.name)
	# print(response.societies)
	# print(response.phases)
		game_fetched.emit(response)
