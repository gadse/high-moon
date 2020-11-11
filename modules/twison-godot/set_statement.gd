extends Object

class_name SetStatement

var start_index: int = -1
var end_index: int = -1
var variable_name: String = ""
var target_value: bool = false

func _init(start_index, end_index, variable_name, target_value):
	assert(typeof(target_value) == TYPE_BOOL)
	self.start_index = start_index
	self.end_index = end_index
	self.variable_name = variable_name
	self.target_value = target_value

func length():
	return end_index - start_index + 1

func eval(knowledge_base):
	"""
	We want to update our character's knowledge using this SetStatement.
	
	Args:
		knowledge_base (dict): A dictionary representing boolean and integer
			knowledge.
	
	Returns:
		The new value.
	"""
	# Gdscript only passes base type by value, so this is fine :3
	knowledge_base[variable_name] = self.target_value
	return knowledge_base[variable_name]
