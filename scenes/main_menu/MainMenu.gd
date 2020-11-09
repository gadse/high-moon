extends TextureRect

const Game = preload("res://scenes/game/Game.tscn")

func _on_NewGameButton_pressed():
	var game = Game.instance()
	self.add_child(game)

func _on_ExitButton_pressed():
	get_tree().quit()
