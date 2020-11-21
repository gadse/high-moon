extends TextureRect

var TwisonHelper = preload("res://modules/twison-godot/twison_helper.gd")
var Dialog = preload("res://scenes/templates/dialog/Dialog.tscn")
var story = TwisonHelper.new()

const number_keys = [
	KEY_0,
	KEY_1,
	KEY_2,
	KEY_3,
	KEY_4,
	KEY_5,
	KEY_6,
	KEY_7,
	KEY_8,
	KEY_9,
	KEY_0
]

var current_passage = null
var just_starting = false

func _ready():
	#$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_in()

	story.parse_file("examples/example_story.json")
	current_passage = story.start()
	$Info.text = story.get_story_name() + "\n" + current_passage.text
	_output_links(current_passage)

func _input(event):
	if event is InputEventMouseButton and \
			event.is_pressed() and \
			event.button_index == BUTTON_LEFT:
		print("registered left click")
		if story.is_finished():
			print("FINISHED")
			$Info.text = current_passage.text + "\n"
			#$Fader.fade_out()
		else:
			story.traverse(0)
			$Info.text = current_passage.text + "\n"
			_output_links(current_passage)

func _output_links(passage):
	var ix: int = 0
	for link in passage.links:
		$Info.text += "\n"
		$Info.text += String(ix) + "> " + link.name

func _on_Experimental_FadeOut_button_up():
	$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_out()
	pass # Replace with function body.

func _start_dialog():
	print("_start_dialog")
	$Fader.disconnect("faded_out", self, "_start_dialog")
	var dialog = Dialog.instance()
	dialog.connect("tree_exited", self, "_show_this")
	self.add_child(dialog)

func _show_this():
	$Fader.fade_in()
