extends ColorRect

var game_scenes = [
	preload("res://scenes/intro/Intro.tscn"),
	preload("res://scenes/town_overview/TownOverview.tscn"),
	preload("res://scenes/kill_scene/KillScene.tscn"),
	preload("res://scenes/epilogue/Epilogue.tscn")
]

var current_scene_index = 0

func _ready():
	self._show_next_scene()

func _show_next_scene():
	if self._is_next_scene_available():
		self._switch_to_next_scene()
	else:
		queue_free()

func _is_next_scene_available():
	return current_scene_index < game_scenes.size()

func _switch_to_next_scene():
	var scene = game_scenes[current_scene_index].instance()
	scene.connect("tree_exited", self, "_show_next_scene")
	self.add_child(scene)
	current_scene_index += 1
