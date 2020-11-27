extends Node

enum KnowledgePiece {
	AgnesPerformedDissection,
	BettyHadIncidentWithJack,
	ElizabethIsVampire,
	ElizabethsHusbandsDisappeared,
	ElizabethLoanedMoneyToJack,
	LucasIsVampireHunter,
	WilliamAndJackWereFriends,
	WilliamAndJackHadAFight,
}

enum WorldEvent {
	
}

enum Npc {
	SheriffLucasShort,
	SaloonOwnerElizabethParker,
	ScientistAgnesSummerville,
	PriestWilliamPierce,
	BlacksmithBettyHenderson,
}

var player_knowledge = [
	KnowledgePiece.WilliamAndJackHadAFight
]

var triggered_events = []

var killed = Npc.PriestWilliamPierce
