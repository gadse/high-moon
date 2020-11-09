extends TextureRect

const Credits = preload("res://scenes/credit_screen/Credits.tscn")
const Game = preload("res://scenes/game/Game.tscn")

func _ready():
	self._show_menu()

func _show_menu():
	$VBoxContainer/NewGameButton.grab_focus()
	if not $BackgroundMusic.playing:
		$BackgroundMusic.fade_in()
	$Fader.fade_in()

func _on_NewGameButton_pressed():
	$Fader.connect("faded_out", self, "_start_game")
	$BackgroundMusic.fade_out()
	$Fader.fade_out()

func _start_game():
	$Fader.disconnect("faded_out", self, "_start_game")

	var game = Game.instance()
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

func _quit():
	get_tree().quit()
