extends TextureRect

func _ready():
	$Fader.connect("faded_in", self, "_play_it_is_high_moon")
	$Fader.connect("faded_out", self, "queue_free")

	$ItsHighMoon.connect("finished", self, "_play_gunshot")
	$GunShot.connect("finished", self, "_show_blood_animation")

	$BackgroundMusic.fade_in()
	$Fader.fade_in()

func _play_it_is_high_moon():
	$ItsHighMoon.play()

func _play_gunshot():
	$GunShot.play()

func _show_blood_animation():
	$BloodAnimation.play("BloodAnimation")

func _on_BloodAnimation_animation_finished(_anim_name):
	$BackgroundMusic.fade_out()
	$Fader.fade_out()
