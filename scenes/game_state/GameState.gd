extends Node

enum KnowledgePiece {
	
	TalkedWithAgnes,
	TalkedWithBetty,
	TalkedWithElizabeth,
	TalkedWithLucas,
	TalkedWithWilliam,
	
	AgnesCanBeDueled,
	BettyCanBeDueled,
	ElizabethCanBeDueled,
	LucasCanBeDueled,
	WilliamCanBeDueled,
	
	AgnesKilled,
	BettyKilled,
	ElizabethKilled,
	LucasKilled,
	WilliamKilled,
	
	AgnesIsObsessed,
	AgnesPerformedDissection,
	
	BettyHasBadTemper,
	BettyHadRomanceWithJack,
	BettyHadIncidentWithJack,
	BettyIsWerewolf,
	
	ElizabethHadManyHusbands,
	ElizabethsHusbandsDisappeared,
	ElizabethLoanedMoneyToJack,
	
	LucasHidesCorpse,
	LucasIsVampireHunter,
	
	WilliamWasBandit,
	WilliamWasFriendsWithJack,
	WilliamHadFightWithJack,
}

var player_knowledge = [
	KnowledgePiece.WilliamKilled,
	KnowledgePiece.WilliamWasFriendsWithJack,
	KnowledgePiece.WilliamHadFightWithJack,
	KnowledgePiece.WilliamWasBandit
]

func append(enumString):
	var enumValue = self._stringToEnum(enumString)
	if enumValue != null:
		self.player_knowledge.append(enumValue)
	
	self._update_dependent_values()

func _update_dependent_values():
	self._update_CanBeDueled(KnowledgePiece.AgnesCanBeDueled,
		[KnowledgePiece.AgnesIsObsessed, KnowledgePiece.AgnesPerformedDissection],
		1)

	self._update_CanBeDueled(KnowledgePiece.BettyCanBeDueled,
		[KnowledgePiece.BettyHasBadTemper, KnowledgePiece.BettyIsWerewolf,
		 KnowledgePiece.BettyHadRomanceWithJack, KnowledgePiece.BettyHadIncidentWithJack],
		2)

	self._update_CanBeDueled(KnowledgePiece.ElizabethCanBeDueled,
		[KnowledgePiece.ElizabethHadManyHusbands, KnowledgePiece.ElizabethsHusbandsDisappeared,
		KnowledgePiece.ElizabethLoanedMoneyToJack],
		2)
	
	self._update_CanBeDueled(KnowledgePiece.LucasCanBeDueled,
		[KnowledgePiece.LucasIsVampireHunter, KnowledgePiece.LucasHidesCorpse],
		1)
	
	self._update_CanBeDueled(KnowledgePiece.WilliamCanBeDueled,
		[KnowledgePiece.WilliamWasBandit, KnowledgePiece.WilliamHadFightWithJack],
		1)

func _update_CanBeDueled(can_be_dueled_enum, test_array, number_of_required_enums):
	if self.player_knowledge.has(can_be_dueled_enum):
		return
	
	if self._intersect(self.player_knowledge, test_array).size() >= number_of_required_enums:
		self.player_knowledge.append(can_be_dueled_enum)

func _intersect(left, right):
	var intersection = []
	for item in left:
		if right.has(item):
			intersection.append(item)
	return intersection

func has(enumString):
	var enumValue = self._stringToEnum(enumString)
	return self.player_knowledge.has(enumValue)

func _stringToEnum(knowledge_piece_string):
	for i in range(KnowledgePiece.keys().size()):
		var enum_string = KnowledgePiece.keys()[i]
		if enum_string.to_lower() == knowledge_piece_string.to_lower():
			return i
