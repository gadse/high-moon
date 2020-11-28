extends "res://scenes/epilogue/EpiloguePage.gd"

func _ready():
	if GameState.player_knowledge.has(GameState.KnowledgePiece.ElizabethIsVampire):
		self.add_text("As a vampire, she herself was surely no stranger to that.")
