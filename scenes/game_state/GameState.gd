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
	
	GunshotWasHeard,
	
	DetectiveToldBettyAboutGunshot,
	DetectiveToldBettyAboutVampireHunter,
	DetectiveToldBettyAboutCorpse,
	DetectiveToldAllImportantDetails,
	DetectiveToldBettyAboutOtherPossibleMurderer,
	DetectiveToldBettyHeKnowsAboutRelationshipWithJack,
	
	AgnesIsObsessed,
	AgnesPerformedDissection,
	
	BettyHasBadTemper,
	BettyHadRomanceWithJack,
	BettyHadIncidentWithJack,
	BettyIsWerewolf,
	
	ElizabethsHusbandsDisappeared,
	ElizabethLoanedMoneyToJack,
	
	LucasHidesCorpse,
	LucasIsVampireHunter,
	
	WilliamWasBandit,
	WilliamWasFriendsWithJack,
	WilliamHadFightWithJack,
}

var player_knowledge = []

func append(enumString):
	var enumValue = self._stringToEnum(enumString)
	if enumValue != null:
		self.player_knowledge.append(enumValue)
	
	self._update_dependent_values()

func _update_dependent_values():
	self._update_dependent_value(KnowledgePiece.AgnesCanBeDueled,
		[KnowledgePiece.AgnesIsObsessed, KnowledgePiece.AgnesPerformedDissection],
		1)

	self._update_dependent_value(KnowledgePiece.BettyCanBeDueled,
		[KnowledgePiece.BettyHasBadTemper, KnowledgePiece.BettyIsWerewolf,
		 KnowledgePiece.BettyHadRomanceWithJack, KnowledgePiece.BettyHadIncidentWithJack],
		2)

	self._update_dependent_value(KnowledgePiece.ElizabethCanBeDueled,
		[KnowledgePiece.ElizabethsHusbandsDisappeared, KnowledgePiece.ElizabethLoanedMoneyToJack],
		1)

	self._update_dependent_value(KnowledgePiece.LucasCanBeDueled,
		[KnowledgePiece.LucasIsVampireHunter, KnowledgePiece.LucasHidesCorpse],
		1)

	self._update_dependent_value(KnowledgePiece.WilliamCanBeDueled,
		[KnowledgePiece.WilliamWasBandit, KnowledgePiece.WilliamHadFightWithJack],
		1)

	self._update_dependent_value(KnowledgePiece.DetectiveToldAllImportantDetails,
		[KnowledgePiece.DetectiveToldBettyAboutCorpse, KnowledgePiece.DetectiveToldBettyAboutGunshot,
		KnowledgePiece.DetectiveToldBettyAboutVampireHunter],
		3)

func _update_dependent_value(dependent_enum, test_array, number_of_required_enums):
	if self.player_knowledge.has(dependent_enum):
		return
	
	if self._intersect(self.player_knowledge, test_array).size() >= number_of_required_enums:
		self.player_knowledge.append(dependent_enum)

func _intersect(left, right):
	var intersection = []
	for item in left:
		if right.has(item):
			intersection.append(item)
	return intersection

func clear():
	self.player_knowledge.clear()

func has(enumString):
	var enumValue = self._stringToEnum(enumString)
	return self.player_knowledge.has(enumValue)

func _stringToEnum(knowledge_piece_string):
	for i in range(KnowledgePiece.keys().size()):
		var enum_string = KnowledgePiece.keys()[i]
		if enum_string.to_lower() == knowledge_piece_string.to_lower():
			return i
