extends Object

class_name ConditionalStatement

var start_index: int = -1
var end_index: int = -1
var variable_name: String = ""
var target_value = null
var optional_text: String = ""

func _init(
	start_index,
	end_index,
	variable_name,
	target_value,
	optional_text
):
	self.start_index = start_index
	self.end_index = end_index
	self.variable_name = variable_name
	self.optional_text = optional_text
	
	if typeof(target_value) == TYPE_BOOL:
		self.target_value = target_value
	else:
		push_error("Illegal target value {}".format(typeof(target_value)))
		assert(false)

func eval(knowledge_base):
	"""
	We want to evaluate this expression in the context of our character's
	knowledge.
	
	Args:
		knowledge_base (dict): A dictionary representing boolean and integer
			knowledge.
	
	Returns:
		result (dict): A dictionary with items 'ok' and 'value' denoting the
			evaluation's result and the current value in the knowledge base.
	"""
	var value = knowledge_base.get(self.varible_name, null)
	if value == self.target_value:
		return {"ok": true, "val": value}
	else:
		return {"ok": false, "val": value}
			

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
