extends Node

var messages = {
	"byId": {},
	"allIds": []
}

var index_of_current_screen = 0
var current_screen = null

const FadingScene = preload("res://scenes/scene_templates/fading_scene/FadingScene.tscn")

func _init():
	self._load_messages_from_json_file()

func _load_messages_from_json_file():
	var file = File.new()
	file.open("res://scenes/epilogue/Epilogue.tres", file.READ)
	var data = file.get_as_text()
	messages = parse_json(data)

func _ready():
	self._on_next_screen_requested()

func _on_next_screen_requested():
	if self._is_next_screen_available():
		self._switch_to_next_screen()
	else:
		queue_free()

func _is_next_screen_available():
	return index_of_current_screen < messages["allIds"].size()
	
func _switch_to_next_screen():
	self._show_new_screen()
	index_of_current_screen += 1

func _show_new_screen():
	var screen_id = messages["allIds"][index_of_current_screen]
	
	current_screen = FadingScene.instance()
	current_screen.connect("tree_exited", self, "_on_next_screen_requested")
	current_screen.caption = messages["byId"][screen_id]["text"]
	self.add_child(current_screen)
