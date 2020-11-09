extends ColorRect

signal faded_in
signal faded_out

func fade_in():
	$FadeAnimationPlayer.play("FadeIn")
	
func _on_FadeAnimationPlayer_animation_finished(animation_name):
	match animation_name:
		"FadeIn":
			emit_signal("faded_in")
		"FadeOut":
			emit_signal("faded_out")

func fade_out():
	$FadeAnimationPlayer.play("FadeOut")
