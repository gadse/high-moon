extends TextureRect

const Credits = preload("res://scenes/credit_screen/Credits.tscn")
const Game = preload("res://scenes/game/Game.tscn")

var game = null

func _ready():
	self._show_menu()

func _show_menu():
	if not $BackgroundMusic.playing:
		$BackgroundMusic.fade_in()
	$Fader.fade_in()

func _on_NewGameButton_pressed():
	if game != null:
		$Fader.connect("faded_out", self, "_resume_game")
	else:
		$Fader.connect("faded_out", self, "_start_game")

	$BackgroundMusic.fade_out()
	$Fader.fade_out()

func _resume_game():
	game.visible = true
	$Fader.disconnect("faded_out", self, "_resume_game")

func _start_game():
	$Fader.disconnect("faded_out", self, "_start_game")

	game = Game.instance()
	game.connect("tree_exited", self, "_show_menu")
	self.add_child(game)

func _on_CreditsButton_pressed():
	$Fader.connect("faded_out", self, "_show_credits")
	$Fader.fade_out()

func _show_credits():
	$Fader.disconnect("faded_out", self, "_show_credits")
	var credits = Credits.instance()
	credits.connect("tree_exited", self, "_show_menu")
	self.add_child(credits)

func _on_ExitButton_pressed():
	$Fader.connect("faded_out", self, "_quit")
	$BackgroundMusic.fade_out()
	$Fader.fade_out()

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		self._on_game_paused()

func _on_game_paused():
	$VBoxContainer/NewGameButton.text = "Continue"
	game.visible = false
	$Fader.fade_in()

func _quit():
	get_tree().quit()
