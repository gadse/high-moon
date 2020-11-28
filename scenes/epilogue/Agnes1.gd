extends "res://scenes/epilogue/EpiloguePage.gd"

func _ready():
	if GameState.player_knowledge.has(GameState.KnowledgePiece.AgnesIsObsessed):
		self.add_text("During your friendship, you quickly learned about her fascination, nay, obsession with the supernatural. But only now did you realize what lengths she will go to, to satisfy her thirst for knowledge.")
	if GameState.player_knowledge.has(GameState.KnowledgePiece.AgnesPerformedDissection):
		self.add_text("You found out that she dissected the corpse of the victim of a shootout five years ago. The family of the killed man witnessed firsthand what she is willing to do ‘for science’ when the remains were returned to them.")
