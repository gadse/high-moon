extends Object

class_name SetStatement

var start_index: int = -1
var end_index: int = -1
var variable_name: String = ""

func _init(start_index, end_index, variable_name):
	self.start_index = start_index
	self.end_index = start_index
	self.variable_name = variable_name

func length():
	return end_index - start_index + 1
