extends TextureRect

var expanded = false

var dialog_history = [
	{
		"text": "This is the first thing the NPC said.",
		"owner": "npc"
	},
	{
		"text": "This was our first answer.",
		"owner": "detective"
	},
	{
		"text": "The NPC came back with this clever answer.",
		"owner": "npc"
	},
	{
		"text": "But we had this important thing to say.",
		"owner": "detective"
	},
	{
		"text": "With this serendipitous line, the NPC settled the argument once and for all.",
		"owner": "npc"
	},
	{
		"text": "Unbelievably, we still had something to say. His turn...",
		"owner": "detective"
	}
]

onready var dialog_history_label = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/HistoryContainer/DialogHistory
onready var dialog_history_container = $ExtendableMarginContainer/PanelContainer/VBoxContainer/PanelContainer/VBoxContainer/HistoryContainer
onready var expand_button = $ExtendableMarginContainer/PanelContainer/VBoxContainer/ExpandButton

func _ready():
	self._update_history()
	
func _update_history():
	dialog_history_label.bbcode_text = ""
	for entry in dialog_history:
		if entry["owner"] == "detective":
			dialog_history_label.bbcode_text += entry["text"]
			dialog_history_label.bbcode_text += "\n"
		elif entry["owner"] == "npc":
			dialog_history_label.bbcode_text += "[right]"
			dialog_history_label.bbcode_text += entry["text"]
			dialog_history_label.bbcode_text += "[/right]"
			dialog_history_label.bbcode_text += "\n"

func _on_ExpandButton_pressed():
	expanded = not expanded
	if expanded:
		dialog_history_container.visible = true
		$ExtendableMarginContainer.set_margin_top(20)
		expand_button.text = "v Hide dialog history v"
		yield(get_tree(), "idle_frame")
		dialog_history_container.scroll_vertical = dialog_history_container.get_v_scrollbar().max_value
	else:
		dialog_history_container.visible = false
		$ExtendableMarginContainer.set_margin_top(400)
		expand_button.text = "^ Show dialog history ^"
