extends Object

class_name DecStatement

var start_index: int = -1
var end_index: int = -1
var variable_name: String = ""

func _init(start_index, end_index, variable_name):
	self.start_index = start_index
	self.end_index = start_index
	self.variable_name = variable_name

func length():
	return end_index - start_index + 1

func eval(knowledge_base):
	"""
	We want to update our character's knowledge using this DecStatement.
	
	Args:
		knowledge_base (dict): A dictionary representing boolean and integer
			knowledge.
	
	Returns:
		The new value.
	"""
	# Gdscript only passes base type by value, so this is fine :3
	knowledge_base[variable_name] -= 1
	return knowledge_base[variable_name]
