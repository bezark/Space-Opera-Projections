extends Node3D

var orientation := Quaternion.IDENTITY   # not Quaternion

const GYRO_WEIGHT := 0.98
const SMOOTH_SPEED := 5.0

func _physics_process(delta):
	# 1) Read raw sensors
	var gyro  : Vector3 = Input.get_gyroscope()
	var accel : Vector3 = Input.get_accelerometer()

	# 2) Integrate gyro → tiny rotation delta_q
	if gyro.length() > 0.0:
		var axis  = gyro.normalized()
		var angle = gyro.length() * delta
		var delta_q = Quaternion(axis, angle)
		orientation = (delta_q * orientation).normalized()

	# 3) accel‐only attitude (pitch/roll)
	if accel.length() > 0.1:
		var down   = accel.normalized()
		var pitch  = atan2(-down.x, sqrt(down.y*down.y + down.z*down.z))
		var roll   = atan2(down.y, down.z)
		var q_acc  = Quaternion(Vector3(1,0,0), pitch) * Quaternion(Vector3(0,1,0), roll)
		orientation = orientation.slerp(q_acc, 1.0 - GYRO_WEIGHT).normalized()

	# 4) (opt) magnetometer‐based yaw correction goes here…

	# 5) apply with smoothing
	var target_basis = Basis(orientation)  # <-- wrap quat in Basis
	transform.basis = transform.basis.slerp(target_basis, SMOOTH_SPEED * delta)
