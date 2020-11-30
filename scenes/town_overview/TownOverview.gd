extends TextureRect

var MusicFader = preload("res://scenes/templates/music_fader/MusicFader.tscn")

var background_music = null
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

	background_music.fade_out()
	$Fader.fade_out()

func _show_this():
	dialog = null
	$Fader.fade_in()
	
	background_music = MusicFader.instance()
	background_music.connect("finished", background_music, "queue_free")
	background_music.stream = load("res://scenes/town_overview/Town Winds.ogg")
	self.add_child(background_music)
	background_music.fade_in()

func _enable_kill_scene():
	dialog.disconnect("tree_exited", self, "_show_this")
	dialog.connect("tree_exited", self, "_switch_to_kill_scene")

func _switch_to_kill_scene():
	self.queue_free()

func _on_Agnes_mouse_entered():
	$AgnesLabel.visible = true

func _on_Agnes_mouse_exited():
	$AgnesLabel.visible = false

func _on_Sheriff_mouse_entered():
	$SheriffLabel.visible = true

func _on_Sheriff_mouse_exited():
	$SheriffLabel.visible = false

func _on_Liz_mouse_entered():
	$LizLabel.visible = true

func _on_Liz_mouse_exited():
	$LizLabel.visible = false

func _on_Betty_mouse_entered():
	$BettyLabel.visible = true

func _on_Betty_mouse_exited():
	$BettyLabel.visible = false

func _on_William_mouse_entered():
	$WilliamLabel.visible = true

func _on_William_mouse_exited():
	$WilliamLabel.visible = false
