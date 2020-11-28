extends Node

class_name DialogWalker

var json = null
var knowledge = []

var current_npc_passage = null
var current_player_passage = null

var current_flow_npc_segment_index = 0
var current_flow_npc_line_index = 0

func set_knowledge(knowledge):
	self.knowledge = knowledge

func load_json(json):
	self.json = json
	
	var start_passage = self._find_start_passage()
	self._change_npc_passage(start_passage)
	self._update_player_passage()

func _find_start_passage():
	var start_passage_json = json["start"]
	var start_passage_type = typeof(start_passage_json)
	match start_passage_type:
		TYPE_STRING:
			return start_passage_json
		TYPE_ARRAY:
			for start_passage_candidate in start_passage_json:
				var start_passage_candidate_type = typeof(start_passage_candidate)
				match start_passage_candidate_type:
					TYPE_DICTIONARY:
						if knowledge.has(start_passage_candidate["isSet"]):
							return start_passage_candidate["passageId"]
					TYPE_STRING:
						return start_passage_candidate

func get_npc_text():
	match self._get_passage_type(self.current_npc_passage):
		"linear":
			var text_flow = self.current_npc_passage["flow"]
			return self._get_npc_text_from_flow(text_flow)
		"choice":
			return self.current_npc_passage["npc"]

func _get_npc_text_from_flow(flow):
	return flow[self.current_flow_npc_segment_index][self.current_flow_npc_line_index]

func get_my_texts():
	match self._get_passage_type(self.current_player_passage):
		"linear":
			var text_flow = self.current_npc_passage["flow"]
			return self._get_my_texts_from_flow(text_flow)
		"choice":
			return self._get_my_texts_from_choice(self.current_player_passage)

func _get_my_texts_from_flow(flow):
	if self._has_current_flow_segment_more_npc_lines():
		return ["..."]
	elif self.current_flow_npc_segment_index + 1 < flow.size():
		return flow[self.current_flow_npc_segment_index + 1]
	else:
		return ["..."]

func _get_my_texts_from_choice(choice):
	var answers = []
	for option in choice["me"]:
		if option.has("isSet") and not self.knowledge.has(option["isSet"]):
			continue
		answers.append(option["text"])
	return answers

func answer(answer):
	match self._get_passage_type(self.current_player_passage):
		"linear":
			if self._has_current_flow_segment_more_npc_lines():
				self.current_flow_npc_line_index += 1
			elif self._has_current_flow_more_npc_segments():
				self.current_flow_npc_line_index = 0
				self.current_flow_npc_segment_index += 2
			else:
				self._change_npc_passage(self.current_player_passage["goto"])
		"choice":
			var selected_option = self._find_answer_option_with_text(answer)
			self._change_npc_passage(selected_option["goto"])
	self._update_player_passage()

func _get_passage_type(passage):
	return passage["type"]

func _has_current_flow_segment_more_npc_lines():
	var flow = self.current_npc_passage["flow"]
	if self.current_flow_npc_segment_index < flow.size():
		var current_flow_npc_segment = flow[self.current_flow_npc_segment_index]
		return self.current_flow_npc_line_index < current_flow_npc_segment.size() - 1
	else:
		return false

func _has_current_flow_more_npc_segments():
	var flow = self.current_npc_passage["flow"]
	return self.current_flow_npc_segment_index + 2 < flow.size()

func _change_npc_passage(passage_id):
	self.current_npc_passage = self.json["passages"][passage_id]
	self.current_flow_npc_segment_index = 0
	self.current_flow_npc_line_index = 0
	
	if self.current_npc_passage.has("set"):
		self.knowledge.append(self.current_npc_passage["set"])

func _find_answer_option_with_text(text):
	var options = self.current_player_passage["me"]
	for option in options:
		if option["text"] == text:
			return option

func _update_player_passage():
	self.current_player_passage = self.current_npc_passage
	
	if self._get_passage_type(self.current_npc_passage) == "linear" \
	and not self._has_current_flow_segment_more_npc_lines() \
	and not self._has_current_flow_more_player_segments():
		var next_passage_id = self.current_npc_passage["goto"]
		var next_passage = self.json["passages"][next_passage_id]
		if self._get_passage_type(next_passage) == "choice" \
		and not next_passage.has("npc"):
			self.current_player_passage = next_passage

func _has_current_flow_more_player_segments():
	return self.current_flow_npc_segment_index + 1 < self.current_npc_passage["flow"].size()
