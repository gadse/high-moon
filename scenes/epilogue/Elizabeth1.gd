extends "res://scenes/epilogue/EpiloguePage.gd"

func _ready():
	if GameState.player_knowledge.has(GameState.KnowledgePiece.ElizabethsHusbandsDisappeared):
		self.add_text("Elizabeth has been involved in the mysterious disappearances of men before, but now it seems she picked the one victim she should not have killed.")
	if GameState.player_knowledge.has(GameState.KnowledgePiece.ElizabethLoanedMoneyToJack):
		self.add_text("You found out the wealthy saloon owner also operated as a loan shark, and it seems Jack paid his final debt with his life.")
