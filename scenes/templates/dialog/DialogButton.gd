extends Button

export(String, MULTILINE) var caption

signal answer_button_pressed(object)

func _ready():
	$MarginContainer/Label.text = caption
	# pause one frame so the text gets updated
	yield(get_tree(), "idle_frame")
	# update button size to be equivalent to a label with the same text.
	# Presumably, buttons don't resize to accommodate the text, whereas labels do?
	self.rect_min_size.y = $MarginContainer/Label.rect_size.y + 15

func set_text(text: String):
	self.caption = text
	self._ready()

func _pressed():
	emit_signal("answer_button_pressed", self)

func _exit_tree():
	pass
