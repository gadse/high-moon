extends Node

signal finished

var messages = [
	{
		"text": "You stand above your victim. [color=red]Justice[/color] has been served."
	},
	{
		"text": "The good townsfolk can rest easy now knowing that their town is safe once more."
	}
]

var index_of_current_screen = 0
var current_screen = null

const FadingScene = preload("res://scenes/scene_templates/fading_scene/FadingScene.tscn")

func _ready():
	self._on_next_screen_requested()

func _on_next_screen_requested():
	if self._is_next_screen_available():
		self._switch_to_next_screen()
	else:
		emit_signal("finished")

func _is_next_screen_available():
	return index_of_current_screen < messages.size()
	
func _switch_to_next_screen():
	self._delete_old_screen()
	self._show_new_screen()
	index_of_current_screen += 1

func _delete_old_screen():
	if current_screen:
		self.remove_child(current_screen)

func _show_new_screen():
	current_screen = FadingScene.instance()
	current_screen.connect("faded_out", self, "_on_next_screen_requested")
	current_screen.caption = messages[index_of_current_screen]["text"]
	self.add_child(current_screen)
