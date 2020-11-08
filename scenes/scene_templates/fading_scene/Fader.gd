extends ColorRect

signal faded_in

var is_fading_in = true

func _ready():
	$FadeAnimationPlayer.play("FadeIn")
	
func _on_FadeAnimationPlayer_animation_finished(_animation_name):
	if is_fading_in:
		is_fading_in = false
		emit_signal("faded_in")
	else:
		queue_free()

func fade_out():
	$FadeAnimationPlayer.play_backwards("FadeIn")
