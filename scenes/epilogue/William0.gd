extends "res://scenes/epilogue/EpiloguePage.gd"

func _ready():
	if GameState.player_knowledge.has(GameState.KnowledgePiece.WilliamAndJackWereFriends):
		self.add_text("You found out about Jack’s and William’s shared evenings. There was of course much reason for them to keep their relationship a secret. It seems the two were rather close – a lovers’ spat, maybe?")
	if GameState.player_knowledge.has(GameState.KnowledgePiece.WilliamAndJackHadAFight):
		self.add_text("Jack and William had a serious fight the night Jack was killed, just a few hours before his corpse turned up. It is just far too suspicious.")
