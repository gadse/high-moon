extends Node2D

func _ready():
	$Fader.connect("faded_in", $Fader, "init")
	$Fader.connect("faded_out", self, "queue_free")

	$Fader.fade_in()

func init():
	pass


func _on_Experimental_FadeOut_button_up():
	$Fader.fade_out()
	pass # Replace with function body.
