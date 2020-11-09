extends TextureRect

export(String, FILE) var background_image
export(String, MULTILINE) var caption
export(int) var fade_out_timeout = 10

func _ready():
	$Fader.connect("faded_in", $FadeOutTimer, "start")
	$Fader.connect("faded_out", self, "queue_free")
	
	if background_image:
		self.texture = load(background_image)
	$MarginContainer/Caption.bbcode_text = caption
	$FadeOutTimer.wait_time = fade_out_timeout

	$Fader.fade_in()

func _on_FadeOutTimer_timeout():
	$Fader.fade_out()

func _on_EpiloguePage_gui_input(event):
	if event.is_pressed() and event.button_index == BUTTON_LEFT:
		$Fader.fade_out()
