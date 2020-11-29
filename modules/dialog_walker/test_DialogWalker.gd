extends "res://addons/gut/test.gd"

var DialogWalker = preload("res://modules/dialog_walker/DialogWalker.gd")

var default_json = {
	"start": "linear",
	"passages": {
		"linear": {
			"type": "linear",
			"flow": [
				[
					"This is what the NPC says."
				],
				[
					"This is my answer."
				]
			],
			"set": "secret"
		},
		"choice": {
			"type": "choice",
			"npc": "Am I asking you something?",
			"me": [
				{
					"text": "Yes.",
					"goto": "positive"
				},
				{
					"text": "No.",
					"goto": "negative"
				}
			]
		},
		"positive": {
			"type": "linear",
			"flow": [
				[
					"This is correct."
				],
				[
					"I am so glad."
				]
			]
		},
		"negative": {
			"type": "linear",
			"flow": [
				[
					"Wrong!"
				],
				[
					"Damn it."
				]
			]
		},
		"firstPart": {
			"type": "linear",
			"flow": [
				[
					"This is my first line."
				]
			],
			"goto": "secondPart"
		},
		"secondPart": {
			"type": "linear",
			"flow": [
				[
					"This is my second line."
				]
			],
			"goto": "thirdPart"
		},
		"thirdPart": {
			"type": "choice",
			"me": [
				{
					"text": "My turn."
				}
			]
		},
		"conditionalChoice": {
			"type": "choice",
			"npc": "What do you wanna know?",
			"me": [
				{
					"text": "I don't have any questions...",
					"goto": "noQuestions"
				},
				{
					"text": "Tell me more about this secret.",
					"isSet": "secret",
					"goto": "secretDialog"
				}
			]
		}
	}
}

func test_it_gets_the_only_start_node():
	var walker = DialogWalker.new()
	walker.load_json(default_json)
	assert_eq(walker.get_npc_text(), "This is what the NPC says.")
	assert_eq(walker.get_my_texts(), ["This is my answer."])
	walker.free()

func test_it_gets_a_conditional_start_node():
	var test_json = default_json.duplicate(true)
	test_json["start"] = [
		{
			"passageId": "linear",
			"isSet": "specialCondition"
		}
	]
	
	var walker = DialogWalker.new()
	walker.set_knowledge(["specialCondition"])
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "This is what the NPC says.")
	assert_eq(walker.get_my_texts(), ["This is my answer."])
	walker.free()

func test_it_uses_fallback_if_no_conditional_start_node_is_valid():
	var test_json = default_json.duplicate(true)
	test_json["start"] = [
		{
			"passageId": "notExistent",
			"isSet": "specialCondition"
		},
		"linear"
	]
	
	var walker = DialogWalker.new()
	walker.set_knowledge([])
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "This is what the NPC says.")
	assert_eq(walker.get_my_texts(), ["This is my answer."])
	walker.free()

func test_it_returns_multiple_answers_for_flow():
	var test_json = default_json.duplicate(true)
	test_json["passages"]["linear"]["flow"][1].append("This is my other answer.")
	
	var walker = DialogWalker.new()
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "This is what the NPC says.")
	assert_eq(walker.get_my_texts(), ["This is my answer.", "This is my other answer."])
	walker.free()

func test_it_handles_list_of_npc_texts_for_flow():
	var test_json = default_json.duplicate(true)
	test_json["passages"]["linear"]["flow"][0].append("He also has this to say.")
	
	var walker = DialogWalker.new()
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "This is what the NPC says.")
	assert_eq(walker.get_my_texts(), ["..."])
	walker.free()

func test_it_handles_flow_continue_answer():
	var test_json = default_json.duplicate(true)
	test_json["passages"]["linear"]["flow"][0].append("He also has this to say.")
	
	var walker = DialogWalker.new()
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "This is what the NPC says.")
	assert_eq(walker.get_my_texts(), ["..."])
	walker.answer("...")
	assert_eq(walker.get_npc_text(), "He also has this to say.")
	assert_eq(walker.get_my_texts(), ["This is my answer."])
	walker.free()

func test_it_handles_choice_answers():
	var test_json = default_json.duplicate(true)
	test_json["start"] = "choice"
	
	var walker = DialogWalker.new()
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "Am I asking you something?")
	assert_eq(walker.get_my_texts(), ["Yes.", "No."])
	walker.answer("Yes.")
	assert_eq(walker.get_npc_text(), "This is correct.")
	assert_eq(walker.get_my_texts(), ["I am so glad."])
	walker.free()

func test_it_sets_knowledge():
	var knowledge = []
	
	var walker = DialogWalker.new()
	walker.set_knowledge(knowledge)
	walker.load_json(default_json)
	assert_eq(knowledge, ["secret"])
	walker.free()

func test_it_handles_goto():
	var test_json = default_json.duplicate(true)
	test_json["start"] = "firstPart"
	
	var walker = DialogWalker.new()
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "This is my first line.")
	assert_eq(walker.get_my_texts(), ["..."])
	walker.answer("...")
	assert_eq(walker.get_npc_text(), "This is my second line.")
	assert_eq(walker.get_my_texts(), ["My turn."])
	walker.free()

func test_it_hides_conditional_answers():
	var test_json = default_json.duplicate(true)
	test_json["start"] = "conditionalChoice"
	
	var walker = DialogWalker.new()
	walker.load_json(test_json)
	assert_eq(walker.get_npc_text(), "What do you wanna know?")
	assert_eq(walker.get_my_texts(), ["I don't have any questions..."])
	walker.free()
