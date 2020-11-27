extends "res://scenes/epilogue/EpiloguePage.gd"

func _ready():
	if GameState.player_knowledge.has(GameState.KnowledgePiece.AgnesPerformedDissection):
		self.add_text("You found out that she dissected the corpse of the victim of a shootout five years ago. The family of the killed man witnessed firsthand what she is willing to do ‘for science’ when the remains were returned to them.")
