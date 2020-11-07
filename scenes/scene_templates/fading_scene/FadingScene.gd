extends MarginContainer

signal faded_out

export(String, FILE) var background_image
export(String, MULTILINE) var caption
export(int) var fade_out_timeout = 10

var is_fading_in = true

func _ready():
	$BackgroundImage.texture = load(background_image)
	$RichTextLabel.bbcode_text = caption
	$FadeOutTimer.wait_time = fade_out_timeout
	
	$FadeAnimationPlayer.play("FadeIn")
	
func _on_FadeAnimationPlayer_animation_finished(animation_name):
	if is_fading_in:
		is_fading_in = false
		$FadeOutTimer.start()
	else:
		emit_signal("faded_out")

func _on_FadeOutTimer_timeout():
	$FadeAnimationPlayer.play_backwards("FadeIn")
