extends SubViewport

var active_cam: SystemCamera

const CELESTIAL_BODY = preload("res://Components/CelestialBodies/celestial_body.tscn")

func _on_camera_select_cam_selected(cam: SystemCamera) -> void:
	active_cam = cam


func _on_control_body_added(scene_data: SceneData) -> void:
	var new_celestial_body = CELESTIAL_BODY.instantiate()
	new_celestial_body.scene_data = scene_data
	new_celestial_body.global_transform = active_cam.global_transform
	$Kin.add_child(new_celestial_body)
	if active_cam is OrbitalCamera:
		print(active_cam.focus.sattelites)
		active_cam.focus.sattelites.append(new_celestial_body)
		var remote_transform = RemoteTransform3D.new()
		remote_transform.update_rotation = false
		remote_transform.remote_path = new_celestial_body.get_path()
		active_cam.focus.body.add_child(remote_transform)
		new_celestial_body.get_node("VBoxContainer").name = "FINDME"
	$"../Control".check_for_controls()
