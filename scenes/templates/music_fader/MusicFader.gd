extends AudioStreamPlayer

export var fade_duration = 1.00

func _ready():
	$FadeInTween.interpolate_property(self, "volume_db", -80, 0, fade_duration, Tween.TRANS_SINE, Tween.EASE_IN, 0)
	$FadeOutTween.interpolate_property(self, "volume_db", 0, -80, fade_duration, Tween.TRANS_SINE, Tween.EASE_IN, 0)

func _on_FadeOutTween_tween_completed(object, _key):
	object.stop()

func fade_in():
	self.play()
	$FadeInTween.start()

func fade_out():
	$FadeOutTween.start()
