extends TextureRect

var dialog = null

func _ready():
	$Fader.connect("faded_out", self, "_show_dialog_scene")
	self._show_this()

func _show_dialog_scene():
	self.add_child(dialog)

func _on_dialog_icon_clicked(dialog_scene):
	if dialog != null:
		return

	dialog = dialog_scene.instance()
	dialog.connect("kill_scene_triggered", self, "_enable_kill_scene")
	dialog.connect("tree_exited", self, "_show_this")
	$Fader.fade_out()

func _show_this():
	dialog = null
	$Fader.fade_in()

func _enable_kill_scene():
	dialog.disconnect("tree_exited", self, "_show_this")
	dialog.connect("tree_exited", self, "_switch_to_kill_scene")

func _switch_to_kill_scene():
	self.queue_free()
