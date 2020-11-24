extends TextureRect

var Dialog = preload("res://scenes/templates/dialog/Dialog.tscn")


func _ready():
	#$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_in()

func _on_Experimental_FadeOut_button_up():
	$Fader.connect("faded_out", self, "queue_free")
	$Fader.fade_out()
	pass # Replace with function body.

func _start_dialog():
	print("_start_dialog")
	$Fader.disconnect("faded_out", self, "_start_dialog")
	var dialog = Dialog.instance()
	dialog.connect("tree_exited", self, "_show_this")
	self.add_child(dialog)

func _show_this():
	$Fader.fade_in()
