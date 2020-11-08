extends Object

class_name ConditionalStatement

enum ComparisonType {
	eq,
	gte
}

const comp_repr_to_type = {
	"is": ComparisonType.eq ,
	">=": ComparisonType.gte
}

var varible_name: String = ""
var comparison_type = null
var target_value = null

func _init(variable_name, comparison_repr, target_value):
	self.varible_name = variable_name
	
	self.comparison_type = comp_repr_to_type.get(comparison_repr, null)
	if self.comparison_type == null:
		push_error("Illegal comparison used: {}".format(comparison_repr))
		assert(false)
	
	if typeof(target_value) == TYPE_INT:
		self.target_value = int(target_value)
	else:
		self.target_value = bool(target_value)
		# We want to allow expressions like (if: $knows >= True)
		self.comparison_type = ComparisonType.eq

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
	
	if self.comparison_type == ComparisonType.eq:
		if value == self.target_value:
			return {"ok": true, "val": value}
		else:
			return {"ok": false, "val": value}
	elif self.comparison_type == ComparisonType.gte:
		if value >= self.target_value:
			return {"ok": true, "val": value}
		else:
			return {"ok": false, "val": value}
			

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
