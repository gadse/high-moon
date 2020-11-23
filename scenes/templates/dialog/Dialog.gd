extends TextureRect

# TODO: Start with empty dialog_history
# TODO: Open Story (parse the dialog json)
# TODO: Upon passage entry, add the passsage's text to the dialog_history
# TODO: Upon user input, add the chosen option to the dialog_history and go to next passage

const arrow_up_icon = preload("res://scenes/templates/dialog/keyboard_arrow_up-white-18dp.svg")
const arrow_down_icon = preload("res://scenes/templates/dialog/keyboard_arrow_down-white-18dp.svg")
const Story = preload("res://modules/twison-godot/twison_helper.gd")

var expanded = false
var story: Story = null
var current_passage: Dictionary = {}

var button_numbers: Dictionary = {}

const PLAYER = "detective"
const NPC = "npc"
func _new_dialog_entry(text: String, owner: String):
	if owner != NPC and owner != PLAYER:
		push_error("Unknown dialog entry owner: %s".format(owner))
		assert(false)
	else:
		return {
			"text": text,
			"owner": owner
		}

# List of dicts of dialog entries
var dialog_history = [
]

onready var dialog_history_label = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/HistoryContainer/DialogHistory
onready var dialog_history_container = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/HistoryContainer
onready var expand_button = $ExtendableMarginContainer/PanelContainer/VBoxContainer/ExpandButton
onready var answer_buttons = $ExtendableMarginContainer/PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children()

func _init():
	story = Story.new()
	story.parse_file("examples/example_story.json")
	current_passage = story.start()
	dialog_history.append(
		_new_dialog_entry(current_passage.text, NPC)
	)


func _ready():
	self._update_history()
	self._fill_button_numbers_and_wire_signals()
	self._fill_button_texts(current_passage)
	
func _update_history():
	dialog_history_label.bbcode_text = ""
	for entry in dialog_history:
		if entry["owner"] == "detective":
			dialog_history_label.bbcode_text += "[color=gray]"
			dialog_history_label.bbcode_text += entry["text"]
			dialog_history_label.bbcode_text += "[/color]"
			dialog_history_label.bbcode_text += "\n"
		elif entry["owner"] == "npc":
			dialog_history_label.bbcode_text += "[right]"
			dialog_history_label.bbcode_text += entry["text"]
			dialog_history_label.bbcode_text += "[/right]"
			dialog_history_label.bbcode_text += "\n"


func _fill_button_numbers_and_wire_signals():
	if button_numbers.size() == 0:
		var ix = 0
		for button in answer_buttons:
			button_numbers[button] = ix
			button.connect("answer_button_pressed", self, "_on_button_pressed")
			ix += 1

func _fill_button_texts(passage):
	var ix = 0
	for button in answer_buttons:
		if ix < passage.links.size():
			button.set_text(passage.links[ix].name)
		else:
			button.set_text("")
		ix += 1


func _on_ExpandButton_pressed():
	expanded = not expanded
	if expanded:
		$ExtendableMarginContainer.set_margin_top(20)
		expand_button.icon = arrow_down_icon
		expand_button.text = "Hide dialog history"
		yield(get_tree(), "idle_frame")
		dialog_history_container.visible = true
		if dialog_history_container.get_v_scrollbar().visible:
			dialog_history_container.scroll_vertical = dialog_history_container.get_v_scrollbar().max_value
	else:
		$ExtendableMarginContainer.set_margin_top(400)
		expand_button.icon = arrow_up_icon
		expand_button.text = "Show dialog history"
		dialog_history_container.visible = false
		
func _on_button_pressed(object):
	self._choose_answer(button_numbers[object])

func _choose_answer(answer_ix: int):
	var answer_text = current_passage.links[answer_ix].name
	dialog_history.append(_new_dialog_entry(answer_text, PLAYER))
	current_passage = story.traverse(answer_ix)
	_update_history()
	self._fill_button_texts(current_passage)
	pass
	
