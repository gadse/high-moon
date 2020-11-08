extends ColorRect

func _ready():
	$Fader.connect("faded_in", $Fader, "fade_out")
	$Fader.connect("tree_exited", self, "queue_free")
