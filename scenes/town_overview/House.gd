extends Node2D

export var house :String

#func _input(event):
#	if event is InputEventMouseButton:
#		if event.is_pressed() and event.button_index == BUTTON_LEFT:
#			get_node("../Info").set_text(house + " house clicked")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			get_node("../Info").set_text(house + " house clicked")
			get_node("../Fader").connect("faded_out", get_parent(), "_start_dialog")
			get_node("../Fader").fade_out()
