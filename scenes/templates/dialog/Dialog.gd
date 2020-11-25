extends TextureRect

################################
# TODO (gadse): Add stuff to display upon story end.
# TODO (gadse): Check if (set:) and (if:)[] work as intended.
################################

const arrow_up_icon = preload("res://scenes/templates/dialog/keyboard_arrow_up-white-18dp.svg")
const arrow_down_icon = preload("res://scenes/templates/dialog/keyboard_arrow_down-white-18dp.svg")
const Story = preload("res://modules/twison-godot/twison_helper.gd")

const PLAYER = "detective"
const NPC = "npc"

export(String, FILE) var story_file
export(String, FILE) var background_image
export(String, FILE) var character_image

var expanded = false
var story: Story = null
var current_passage: Dictionary = {}

var button_numbers: Dictionary = {}

# List of dicts of dialog entries
var dialog_history = []

onready var dialog_history_label = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/HistoryContainer/DialogHistory
onready var dialog_history_container = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/HistoryContainer
onready var expand_button = $ExtendableMarginContainer/PanelContainer/VBoxContainer/ExpandButton
onready var answer_buttons = $ExtendableMarginContainer/PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children()
onready var npc_text = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/NpcText

func _ready():
	story = Story.new()
	story.parse_file(story_file)
	current_passage = story.start()
	dialog_history.append(
		_new_dialog_entry(current_passage.text, NPC)
	)
	
	self.texture = load(background_image)
	$CharacterPicture.texture = load(character_image)
	
	self._update_history()
	self._fill_button_numbers_and_wire_signals()
	self._fill_button_texts(current_passage)
	self._fill_npc_text(current_passage)
	
	$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_in()

func _new_dialog_entry(text: String, owner: String):
	if owner != NPC and owner != PLAYER:
		push_error("Unknown dialog entry owner: %s".format(owner))
		assert(false)
	else:
		return {
			"text": text,
			"owner": owner
		}

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
	for ix in answer_buttons.size():
		var button = answer_buttons[ix]
		if story.is_finished():
			button.set_visible(true)
			button.set_text("")
		else:
			if ix < passage.links.size():
				button.set_visible(true)
				button.set_text(passage.links[ix].name)
			else:
				button.set_visible(false)
				button.set_text("")

func _fill_npc_text(passage):
	npc_text.bbcode_text = "[right]" + passage.text

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
	if not current_passage.empty():
		dialog_history.append(_new_dialog_entry(current_passage.text, NPC))
		self._update_history()
		self._fill_npc_text(current_passage)
		self._fill_button_texts(current_passage)
	else:
		$Fader.fade_out()
