extends Node
class_name bs64

const mapping := [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/", "=",
]

static func encode(bytes: PackedByteArray) -> String:
	return ""

static func decode(str: String) -> PackedByteArray:
	var ret := PackedByteArray()
	var cutoff: int = 0
	
	# Buffer size with padding
	ret.resize(str.length() * 6 / 8)
	
	for i in range(str.length()):
		var val := int(mapping.find(str[i]))
		
		# If we find padding find how much we need to cut off
		if str[i] == "=":
			if i == str.to_utf8_buffer().size() - 1:
				cutoff = 1
			else:
				cutoff = 2
			break
		
		# Arrange bits in 8 bit chunks from 6 bit
		var index: int = ceil(float(i) * 6.0 / 8.0)
		var splash: int = val >> ((3 - (i % 4)) * 2)
		if splash != 0:
			ret[index - 1] += splash
		if index >= ret.size():
			break
			
		ret[index] += val << (2 + (i % 4) * 2)

	return ret.slice(0, ret.size() - cutoff)
