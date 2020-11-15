extends Node2D

var TwisonHelper = preload("res://modules/twison-godot/twison_helper.gd")
var story = TwisonHelper.new()

var starting_node = null
var next_passage_index = null
var cur_passage_index = null
var cur_passage


func _ready():
	$Fader.connect("faded_in", $Fader, "init")
	$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_in()

	story.parse_file("example_story.json")
	starting_node = story.get_starting_node()
	cur_passage_index = starting_node
	cur_passage = story.get_passage(cur_passage_index)


func _input(event):
	if event.is_pressed() and event.button_index == BUTTON_LEFT:
		if cur_passage_index == -1:
			$Fader.fade_out()
		else:
			var is_last_passage = false # story.has_passage(story.get_passage(cur_passage_index).)
			$Info.text = cur_passage.text + "\n"
			for link in cur_passage.links:
				# $Label.text += "\n"
				$Info.text += "> " + link.name


func init():
	pass


func _on_Experimental_FadeOut_button_up():
	$Fader.fade_out()
	pass # Replace with function body.
