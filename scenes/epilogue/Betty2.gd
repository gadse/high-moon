extends "res://scenes/epilogue/EpiloguePage.gd"

func _ready():
	if GameState.player_knowledge.has(GameState.KnowledgePiece.WilliamWasFriendsWithJack):
		self.add_text("Jack and William spent many late hours in each other’s company. Betty might have had reason to be jealous, making this a crime of passion.")
