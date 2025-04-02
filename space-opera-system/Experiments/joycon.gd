extends Node

@export var delay = 10

var current_step = 0
var udp := PacketPeerUDP.new()
var server_ip = "127.0.0.1"  # Change this if your server is running on another machine
var server_port = 26760  # Default DSU protocol port
#var peer
signal accel_changed
#func _input(event: InputEvent) -> void:
	#print(event)


func _ready():
	print(Engine.get_singleton("Hid"))
	#var devices = Hid.list_devices()
	#print(devices)
	
	#peer = PacketPeerUDP.new()
	#peer.bind(7878)
	#udp.set_dest_address(server_ip, server_port)
	#
	 ##Construct and send the handshake packet
	#var handshake_packet = construct_handshake_packet()
	#udp.put_packet(handshake_packet)


func _process(_delta):
	pass
	#if peer.get_available_packet_count() > 0:
		#var array_bytes = peer.get_packet()
		#var packet_string = array_bytes.get_string_from_ascii()
		#print("Received message: ", packet_string)
		
	#current_step +=1
	#if current_step >= delay:
		#current_step = 0
		#if udp.get_available_packet_count() > 0:
			#var packet = udp.get_packet()
			##var array_bytes = peer.get_packet()
			##var packet_string = array_bytes.get_string_from_utf32()
			##print("Received message: ", packet_string)
			#process_received_packet(packet)


func _on_osc_server_message_received(address, value, time):
	print(value)
	print("Sent handshake packet to register for motion data")


	
func construct_handshake_packet() -> PackedByteArray:
	var packet = PackedByteArray()
	
	# DSUS header
	packet.append_array("DSUS".to_utf8_buffer()) 
	
	# Protocol version (0x03E9 in little-endian)
	packet.append(0xE9)
	packet.append(0x03)
	
	# Length field (payload length + 4 bytes for CRC, setting this as 16 for simplicity)
	packet.append(16 & 0xFF)
	packet.append((16 >> 8) & 0xFF)
	
	# Placeholder for CRC32 (4 zeroed bytes, some servers may ignore this)
	packet.append_array([0x00, 0x00, 0x00, 0x00])
	
	# Server ID (set to all 0xFF)
	packet.append_array([0xFF, 0xFF, 0xFF, 0xFF])
	
	# Message type (0x02, 0x00, 0x10, 0x00) - "data" request
	packet.append_array([0x02, 0x00, 0x10, 0x00])
	
	# Registration ID (0 for all controllers)
	packet.append(0x00)
	
	# Slot ID (0 for first controller slot)
	packet.append(0x00)
	
	return packet

func process_received_packet(packet: PackedByteArray):
	# Motion data should be somewhere in this packet; for now, just print raw data
	print("Received packet: ", packet)
	
	#if packet.size() < 60:
		#print("Packet too short, ignoring.")
		#return
	#
	## Extract accelerometer data (X, Y, Z)
	#var accel_y = bytes_to_int16(packet[38], packet[39])
	#var accel_x = bytes_to_int16(packet[36], packet[37])
	#var accel_z = bytes_to_int16(packet[40], packet[41])
	#
	## Extract gyroscope data (X, Y, Z)
	#var gyro_x = bytes_to_int16(packet[48], packet[49])
	#var gyro_y = bytes_to_int16(packet[50], packet[51])
	#var gyro_z = bytes_to_int16(packet[52], packet[53])
	#
	#print("Accel (X,Y,Z): ", accel_x, ", ", accel_y, ", ", accel_z)
	#print("Gyro (X,Y,Z): ", gyro_x, ", ", gyro_y, ", ", gyro_z)

	if packet.size() < 100:
		print("Packet too short, ignoring. Size:", packet.size())
		return
	#print(packet.decode_half(68))
	# Extract accelerometer data (potential new offsets)
	var accel_x = packet.decode_float(45)
	var accel_y = packet.decode_float(49)
	var accel_z = packet.decode_float(53)
	#
	var gyro_x = packet.decode_float(57)
	var gyro_y = packet.decode_float(61)
	var gyro_z = packet.decode_float(65)
	#prints(accel_x, acc)
	## Extract gyroscope data (potential new offsets)
	#var gyro_x = bytes_to_int16(packet[88], packet[89])
	#var gyro_y = bytes_to_int16(packet[90], packet[91])
	#var gyro_z = bytes_to_int16(packet[92], packet[93])
	#prints(accel_x, accel_y, accel_z, gyro_x,gyro_y,gyro_z)

	#print("Accel (X,Y,Z): ", accel_x / 4096.0, "g, ", accel_y / 4096.0, "g, ", accel_z / 4096.0, "g")
	#print("Gyro (X,Y,Z): ", gyro_x / 16.4, "°/s, ", gyro_y / 16.4, "°/s, ", gyro_z / 16.4, "°/s")
	accel_changed.emit(Vector3(accel_x, accel_y, accel_z))
func bytes_to_int16(high: int, low: int) -> int:
	var value = (high << 8) | low
	if value >= 32768:
		value -= 65536
	return value
