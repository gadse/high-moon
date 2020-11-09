extends TextureRect

func _ready():
	$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_in()

func _on_Credits_gui_input(event):
	if event.is_pressed() and event.button_index == BUTTON_LEFT:
		$Fader.fade_out()
