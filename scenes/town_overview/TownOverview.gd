extends ColorRect

func _ready():
	$Fader.connect("faded_in", $Fader, "fade_out")
	$Fader.connect("faded_out", self, "queue_free")

	$Fader.fade_in()
