extends Button

export(String, MULTILINE) var caption

func _ready():
	$MarginContainer/Label.text = caption
	# pause one frame so the text gets updated
	yield(get_tree(), "idle_frame")
	# update button size to be equivalent to a label with the same text.
	# Presumably, buttons don't resize to accommodate the text, whereas labels do?
	self.rect_min_size.y = $MarginContainer/Label.rect_size.y + 15
	

func _exit_tree():
	pass
