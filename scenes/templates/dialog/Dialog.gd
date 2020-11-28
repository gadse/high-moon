extends TextureRect

################################
# TODO (gadse): Add stuff to display upon story end.
# TODO (gadse): Check if (set:) and (if:)[] work as intended.
################################

signal kill_scene_triggered

const arrow_up_icon = preload("res://scenes/templates/dialog/keyboard_arrow_up-white-18dp.svg")
const arrow_down_icon = preload("res://scenes/templates/dialog/keyboard_arrow_down-white-18dp.svg")
const DialogWalker = preload("res://modules/dialog_walker/DialogWalker.gd")

enum TextOwner {
	Player,
	Npc
}

export(String, FILE) var story_file
export(String, FILE) var background_image
export(String, FILE) var character_image
export(Color, RGB) var character_color

var is_click_to_leave_scene_enabled = false
var expanded = false
var dialog_walker: DialogWalker = null

var button_numbers: Dictionary = {}

# List of dicts of dialog entries
var dialog_history = []

onready var dialog_history_container = $ExtendableMarginContainer/PanelContainer/VBoxContainer/HistoryContainer
onready var dialog_history_scroll_container = dialog_history_container.get_node("ScrollContainer")
onready var dialog_history_label = dialog_history_scroll_container.get_node("DialogHistory")
onready var expand_button = $ExtendableMarginContainer/PanelContainer/VBoxContainer/ExpandButton
onready var answer_buttons = $ExtendableMarginContainer/PanelContainer/VBoxContainer/ScrollContainer/VBoxContainer.get_children()
onready var npc_text = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/NpcText

func _ready():
	self._fill_button_numbers_and_wire_signals()

	self.texture = load(background_image)
	$CharacterPicture.texture = load(character_image)
	npc_text.add_color_override("default_color", character_color)

	if not story_file.empty():
		self._load_story()
		self._update_content_to_current_passage()

	$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_in()

func _fill_button_numbers_and_wire_signals():
	if button_numbers.size() == 0:
		var ix = 0
		for button in answer_buttons:
			button_numbers[button] = ix
			button.connect("answer_button_pressed", self, "_on_button_pressed")
			ix += 1

func _load_story():
	var file = File.new()
	file.open(story_file, file.READ)
	var json_text = file.get_as_text()
	var json = JSON.parse(json_text)
	file.close()
	
	dialog_walker = DialogWalker.new()
	dialog_walker.set_knowledge(GameState)
	dialog_walker.load_json(json.result)

func _add_text_to_history(text, owner):
	match owner:
		TextOwner.Player:
			dialog_history_label.bbcode_text += text
			dialog_history_label.bbcode_text += "\n"
		TextOwner.Npc:
			dialog_history_label.bbcode_text += "[right][color=#" + character_color.to_html(false) + "]"
			dialog_history_label.bbcode_text += text
			dialog_history_label.bbcode_text += "[/color][/right]"
			dialog_history_label.bbcode_text += "\n"

func _fill_button_texts():
	var answers = self.dialog_walker.get_my_texts()
	for ix in answer_buttons.size():
		var button = answer_buttons[ix]
		if ix < answers.size():
			button.set_visible(true)
			button.set_text(answers[ix])
		else:
			button.set_visible(false)
			button.set_text("")

func _fill_npc_text(text):
	npc_text.bbcode_text = "[right]" + text

func _on_ExpandButton_pressed():
	expanded = not expanded
	if expanded:
		$ExtendableMarginContainer.set_margin_top(20)
		expand_button.icon = arrow_down_icon
		expand_button.text = "Hide dialog history"
		yield(get_tree(), "idle_frame")
		dialog_history_container.visible = true
		if dialog_history_scroll_container.get_v_scrollbar().visible:
			dialog_history_scroll_container.scroll_vertical = dialog_history_scroll_container.get_v_scrollbar().max_value
	else:
		$ExtendableMarginContainer.set_margin_top(600)
		expand_button.icon = arrow_up_icon
		expand_button.text = "Show dialog history"
		dialog_history_container.visible = false
		
func _on_button_pressed(object):
	self._choose_answer(button_numbers[object])

func _choose_answer(answer_ix: int):
	var npc_text = self.dialog_walker.get_npc_text()
	self._add_text_to_history(npc_text, TextOwner.Npc)
	var answer_text = self.dialog_walker.get_my_texts()[answer_ix]
	self._add_text_to_history(answer_text, TextOwner.Player)
	self.dialog_walker.answer(answer_text)
	self._update_content_to_current_passage()
	
func _update_content_to_current_passage():
	var text = self.dialog_walker.get_npc_text()
	if text == "Duel":
		emit_signal("kill_scene_triggered")
		$Fader.fade_out()
	elif text == "Exit":
		$ExtendableMarginContainer.visible = false
		$CharacterPicture.visible = false
		$ClickToContinueLabel.visible = true
		is_click_to_leave_scene_enabled = true
	else:
		self._fill_npc_text(text)
		self._fill_button_texts()

func _on_Dialog_gui_input(event):
	if event.is_pressed() and event.button_index == BUTTON_LEFT and is_click_to_leave_scene_enabled:
		$Fader.fade_out()
