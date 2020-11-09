extends TextureRect

func _ready():
	$Fader.connect("faded_in", self, "_play_it_is_high_moon")
	$Fader.connect("faded_out", self, "queue_free")

	$ItsHighMoon.connect("finished", self, "_play_gunshot")
	$GunShot.connect("finished", $Fader, "fade_out")

	$Fader.fade_in()

func _play_it_is_high_moon():
	$ItsHighMoon.play()

func _play_gunshot():
	$GunShot.play()
