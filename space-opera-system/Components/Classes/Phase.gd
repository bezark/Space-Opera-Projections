extends Resource
class_name Phase

@export var id: String
@export var type: String
@export var status: String
@export var sp_round: int
@export var scene_data : SceneData

# @export var duration: float
# @export var timeElapsed: float
 
@export var time = {
	'elapsed'=0.,
	'duration'= 0,
	'remaining'=0,
	'remainingFormatted'= ""
}
