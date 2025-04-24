class_name JoyConParser

# Joy-Con button constants
const BTN_Y = 0x01
const BTN_X = 0x02
const BTN_B = 0x04
const BTN_A = 0x08
const BTN_SR = 0x10
const BTN_SL = 0x20
const BTN_R = 0x40
const BTN_ZR = 0x80

const BTN_MINUS = 0x01
const BTN_PLUS = 0x02
const BTN_RSTICK = 0x04
const BTN_LSTICK = 0x08
const BTN_HOME = 0x10
const BTN_CAPTURE = 0x20

const BTN_DOWN = 0x01
const BTN_UP = 0x02
const BTN_RIGHT = 0x04
const BTN_LEFT = 0x08
const BTN_L = 0x40
const BTN_ZL = 0x80

func parse_joycon_data(data: PackedByteArray):
	if data.size() < 49:  # Joy-Con standard report size
		return null
		
	var result = {}
	
	# First byte is the report ID (usually 0x30 which is 48 decimal)
	result.report_id = data[0]
	
	# Second byte is often a counter that increments with each packet
	result.counter = data[1]
	
	# Third byte is the input report type
	result.input_report_type = data[2]
	
	# Button status (bytes 3-5)
	result.buttons = {
		"right": {
			"y": bool(data[3] & BTN_Y),
			"x": bool(data[3] & BTN_X),
			"b": bool(data[3] & BTN_B),
			"a": bool(data[3] & BTN_A),
			"sr": bool(data[3] & BTN_SR),
			"sl": bool(data[3] & BTN_SL),
			"r": bool(data[3] & BTN_R),
			"zr": bool(data[3] & BTN_ZR)
		},
		"shared": {
			"minus": bool(data[4] & BTN_MINUS),
			"plus": bool(data[4] & BTN_PLUS),
			"r_stick": bool(data[4] & BTN_RSTICK),
			"l_stick": bool(data[4] & BTN_LSTICK),
			"home": bool(data[4] & BTN_HOME),
			"capture": bool(data[4] & BTN_CAPTURE)
		},
		"left": {
			"down": bool(data[5] & BTN_DOWN),
			"up": bool(data[5] & BTN_UP),
			"right": bool(data[5] & BTN_RIGHT),
			"left": bool(data[5] & BTN_LEFT),
			"l": bool(data[5] & BTN_L),
			"zl": bool(data[5] & BTN_ZL)
		}
	}
	
	# Stick data
	# Left stick (bytes 6-8)
	result.left_stick = parse_stick_data(data[6], data[7], data[8])
	
	# Right stick (bytes 9-11)
	result.right_stick = parse_stick_data(data[9], data[10], data[11])
	
	# Accelerometer and gyroscope data is in the remaining bytes
	# Each axis of accelerometer and gyroscope is a 16-bit value
	
	# Accelerometer data (3 axes, 2 bytes each = 6 bytes)
	result.accelerometer = {
		"x": convert_to_signed_16bit(data[13], data[14]),
		"y": convert_to_signed_16bit(data[15], data[16]),
		"z": convert_to_signed_16bit(data[17], data[18])
	}
	
	# Gyroscope data (3 axes, 2 bytes each = 6 bytes)
	result.gyroscope = {
		"x": convert_to_signed_16bit(data[19], data[20]),
		"y": convert_to_signed_16bit(data[21], data[22]),
		"z": convert_to_signed_16bit(data[23], data[24])
	}
	
	return result

# Helper function to parse stick data
func parse_stick_data(byte1: int, byte2: int, byte3: int) -> Dictionary:
	# Stick data is typically encoded as 12-bit values
	# Horizontal is in the lower 8 bits of the first byte + upper 4 bits of the third byte
	# Vertical is in the second byte + remaining 4 bits of the third byte
	var horizontal = ((byte3 & 0xF) << 8) | byte1
	var vertical = ((byte3 >> 4) << 8) | byte2
	
	# Convert to -1.0 to 1.0 range
	var x = (horizontal - 2048) / 2048.0
	var y = (vertical - 2048) / 2048.0
	
	return {"x": x, "y": y}

# Helper function to convert two bytes to a signed 16-bit integer
func convert_to_signed_16bit(lsb: int, msb: int) -> int:
	var value = (msb << 8) | lsb
	# Convert to signed if necessary
	if value >= 32768:  # 2^15
		value -= 65536  # 2^16
	return value
