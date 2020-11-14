extends Button

export(String, MULTILINE) var caption

func _ready():
	$MarginContainer/Label.text = caption
	yield(get_tree(), "idle_frame")
	self.rect_min_size.y = $MarginContainer/Label.rect_size.y + 15
