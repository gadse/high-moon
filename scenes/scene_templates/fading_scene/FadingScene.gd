extends TextureRect

export(String, FILE) var background_image
export(String, MULTILINE) var caption
export(int) var fade_out_timeout = 10

var is_fading_in = true

func _ready():
	if background_image:
		self.texture = load(background_image)
	$Caption.bbcode_text = caption
	$FadeOutTimer.wait_time = fade_out_timeout
	
	$FadeAnimationPlayer.play("FadeIn")
	
func _on_FadeAnimationPlayer_animation_finished(_animation_name):
	if is_fading_in:
		is_fading_in = false
		$FadeOutTimer.start()
	else:
		queue_free()

func _on_FadeOutTimer_timeout():
	self._fade_out()

func _on_FadeBlackRect_gui_input(event):
	if event.is_pressed() and event.button_index == BUTTON_LEFT:
		self._fade_out()

func _fade_out():
	$FadeOutTimer.stop()
	$FadeAnimationPlayer.play_backwards("FadeIn")
