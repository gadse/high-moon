extends Object

const SetStatement = preload("res://modules/twison-godot/set_statement.gd")
const ConditionalStatement = preload("res://modules/twison-godot/conditional_statement.gd")

const statement_headers = {
	"(set:": SetStatement,
	"(if:": ConditionalStatement
}

var knowledge_base = GameState.KnowledgePiece

class StatementSorter:
	static func by_start_index_desc(a, b):
		if a.get_start_index() < b.get_start_index():
			return false
		else:
			return true

# This script allows importing twine stories into godot.
# Please note that only plain text and standart passage links are supported.

var passages = {}
var data = {}

var current_passage_id = null
var current_passage = null

# Tag db is a Dictionary with tag strings as keys, and Arrays of passage pids as values
var _tag_db_enabled = false
var tag_db = {}

# Parses the file for passages
# If this script was already filled with data, it will be lost.
# --------------------------------------------------------------------------------
# linkFilter is a function that accepts a RegExMatch containing link,
# and returns with what this link should be replaced.
# For more info take a look at two example filters provided, and the documentation. 
# --------------------------------------------------------------------------------
# construct_tag_db : If you pass 'true', the tag db will be constructed
# while parsing the file. It allows faster tag operations, especially if there are many of both of them.
# I honestly don't know why you might wanna disable it, but the option is there.
func parse_file(filePath: String, \
				linkFilter: FuncRef = null, \
				construct_tag_db = true):
	data = {}
	passages = {}
	tag_db = {}
	
	data = _load_file(filePath)
	_extract_passages()
	
	if (construct_tag_db):
		_tag_db_enabled = true
		_construct_tag_db()
	
	if (linkFilter == null):
		linkFilter = funcref(self, "link_filter_erase")

	_filter_links(linkFilter)

func _extract_passages():
	for passage in data.passages:
		var pid = int(passage.pid)
		passages[pid] = passage
		
		print("Raw text:\n %s" % passage.text)
		var new_text = _evaluate_and_replace_conditional_statements(passage)
		print("New text:\n %s" % new_text)
		passage.text = new_text
		# TODO: Delete links from link list if they were included inside a 
		#		then or else bracket pair. (check if count is > 2?)
		
		var set_statements = _extract_set_statements(passage)
		passage.text = _remove_set_statements_from_passage_text(set_statements, passage.text)

func _remove_set_statements_from_passage_text(set_statements, text):
	var working_copy :String = String(text)
	for statement in set_statements:
		working_copy.erase(statement.start_index, statement.length())
	return working_copy
	


func _evaluate_and_replace_conditional_statements(passage):
	"""
	Finds and returns all conditional statements. The sequence is the sequence
	in which the statements should be evaluated (last to first).
	
	The iundex-descending order enables us to process the statements in sequence
	without needing to build another structure.
	"""
	var working_copy: String = String(passage.text)
	var found_cond_statements = 0

	while true:
		# Let's try to find the outer edges...
		var start_index: int = working_copy.find_last("(if:")
		if start_index == -1:
			break
		var end_index: int = working_copy.substr(start_index + 1).find_last("]")
		var length = end_index - start_index + 1
		
		# Not let's try to make sense of the stuff...
		var parsing_result = _parse_if_then_else(
			working_copy.substr(start_index, length)
		)
		assert(parsing_result != null)
		
		var before_and_after = working_copy.split(
				working_copy.substr(start_index, length)
			)
		var new_text: String
		if knowledge_base.get(parsing_result.condition):
			new_text = before_and_after[0] \
				+ parsing_result.then_text \
				+ before_and_after[1]
		else:
			new_text = before_and_after[0] \
				+ parsing_result.else_text \
				+ before_and_after[1]
		
		found_cond_statements += 1
	return working_copy

func _parse_if_then_else(substring: String) -> Dictionary:
	"""
	Conditionals can contain links. We need to count brackets... *sigh*
	
	Form: (if:$CONDITION)[THEN_BRANCH](else:)[ELSE_BRANCH]
	"""
	print("parsing %s" % substring )
	var working_copy = String(substring)
	var then_branch_complete = false
	var condition_complete = false
	
	var condition: Dictionary = {}
	var then_branch: Dictionary = {}
	var else_branch: Dictionary = {}
	
	var first_opening_square_bracket = -1
	var last_closing_square_bracket = -1
	var first_opening_round_bracket = -1
	var last_closing_round_bracket = -1
	
	var opening_square_brackets = 0
	var closing_square_brackets = 0
	var opening_round_brackets = 0
	var closing_round_brackets = 0
	
	for ix in working_copy.length():
		var character = working_copy[ix]
		print("Found char %s" % character)
		if character == "[":
			opening_square_brackets += 1
			if first_opening_square_bracket < 0:
				first_opening_square_bracket = ix
		elif character == "]":
			closing_square_brackets += 1
			last_closing_square_bracket = ix
		elif character == "(":
			opening_round_brackets += 1
			if first_opening_round_bracket < 0:
				first_opening_round_bracket = ix
		elif character == ")":
			closing_round_brackets += 1
			last_closing_round_bracket = ix
		else:
			pass
		
		# First time here: We found our IF
		# Second time here: We found our ELSE
		if opening_round_brackets > 0 and \
				opening_round_brackets == closing_round_brackets:
			if not then_branch_complete:
				condition.start_index = first_opening_round_bracket
				condition.end_index = last_closing_round_bracket
				var length = condition.end_index - condition.start_index + 1
				# Leave out the brackets themselves
				condition.text = working_copy.substr(condition.start_index + 1, length - 1)
				condition_complete = true
			else:
				# This part contains no useful info
				pass
		# First time here: We found our THEN
		# Second time here: WE found our ELSE
		if opening_square_brackets > 0 \
				and opening_square_brackets == closing_square_brackets:
			if not then_branch_complete:
				then_branch.start_index = first_opening_square_bracket
				then_branch.end_index = last_closing_square_bracket
				var length = then_branch.end_index - then_branch.start_index + 1
				# Leave out the brackets themselves
				then_branch.text = working_copy.substr(then_branch.start_index + 1, length - 1)
				
				then_branch_complete = true
				
				if working_copy.substr(ix).begins_with("(else"):
					# Our (if:) has an (else:)!
					first_opening_square_bracket = -1
				else:
					return {
						"condition": condition,
						"then_text": then_branch.text,
						"else_text": ""
					}
			else:
				else_branch.start_index = first_opening_square_bracket
				else_branch.end_index = last_closing_square_bracket
				var length = else_branch.end_index - else_branch.start_index + 1
				else_branch.text = working_copy.substr(else_branch.start_index + 1, length - 1)
				
				return {
					"condition": condition,
					"then_text": then_branch.text,
					"else_text": else_branch.text
				}
	
	# We can land here for several reasons:
	# a) We never found a point where opening and closing round brackets match.
	if not condition_complete:
		_abort("Parsing error at condition. Matching round brackets not found")

	# b) We did but then we found no matching square brackets.
	if not then_branch_complete:
		_abort("Parsing error at then branch. Matching square brackets not found.")
	return {}




func _insert_conditional_text(outer_text, knowledge_base, statement):
	"""
	If the given conditional_statement eval()uates to true, insert its optional
	text at the appropriate position in the outer text.
	
	Args:
		outer_text (String): The outer text of a passage.
		knowledge_base (dict): Our character's knowledge.
		conditional_statement (ConditionalStatement): The (if:)[] statement.
	"""
	if statement.eval(knowledge_base):
		for ix in statement.get_optional_text().size():
			outer_text.insert(
				statement.get_start_index(),
				statement.get_optional_text()[ix]
			)


func _extract_set_statements(passage):
	"""
	Finds and returns all set statements. The sequence is the sequence
	in which the statements should be evaluated (last to first).
	
	The iundex-descending order enables us to process the statements in sequence
	without needing to build another structure.
	"""
	var working_copy: String = String(passage.text)
	var found_set_statements = []
	
	while true:
		var start_index: int = working_copy.find_last("(set:")
		var end_index: int = working_copy.substr(start_index + 1).find(")") + start_index
		
		if start_index > -1 and end_index > -1:
			var length: int = end_index - start_index + 1
			var statement_source: String = working_copy.substr(
					start_index,
					length
			)
			var var_and_val =  statement_source \
					.replacen("(set:$", "") \
					.replacen(")", "") \
					.split("to")
			var value: bool
			if var_and_val.size() == 1:
				value = true
			elif var_and_val.size() == 2:
				value = bool(var_and_val[1].strip_edges().to_lower())
			else:
				push_error(
					"Set statement parsing error at\npassage with pid %s" % passage.pid
				)
				assert(false)
			var set_statement = SetStatement.new(
					start_index,
					end_index,
					var_and_val[0].strip_edges().to_lower(),
					value
			)
			
			found_set_statements.append(set_statement)
			working_copy.erase(start_index, length)
		elif start_index == -1:
			# no set statements present
			break
		elif end_index == -1:
			# Raise error
			push_error("passage parser encountered '(set:' without ')'")
			assert(false)
		else:
			# Nothing to do here
			break
	found_set_statements.sort_custom(StatementSorter, "by_start_index_desc")
	return found_set_statements	


# Constructs tag db. If you pass true as an argument,
# instead of assigning constructed db to global var,
# this funtion will return it.
func _construct_tag_db(return_it: bool = false):
	var tags = {}
	for pid in passages:
		var passage = passages[pid]
		
		if (passage.has("tags")):
			for tag in passage["tags"]:
				if tags.has(tag):
					tags[tag].append(pid)
				else:
					tags[tag] = [pid]
	if (return_it):
		return tags
	else:
		tag_db = tags

func _filter_links(linkFilter: FuncRef):
	# \[\[(.+?(?=\]\]))\]\]
	var link_regex = "\\[\\[(.+?(?=\\]\\]))\\]\\]"
	var reg = RegEx.new()
	reg.compile(link_regex)
	
	var text
	for passage in passages:
		text = passages[passage]["text"]
		
		for result in reg.search_all(text):
			var newLink = linkFilter.call_func(result)
			text = text.replace(result.get_string(), newLink)
		
		text = text.strip_edges(true, true)
		passages[passage]["text"] = text

func _load_file(filePath: String):
	var jsonFile = File.new()
	jsonFile.open(filePath, jsonFile.READ)
	
	if (jsonFile.get_error()):
		printerr("Cannot open json file!")
		return data
	
	var text = jsonFile.get_as_text()
	data = parse_json(text)
	jsonFile.close()

	return data

# Identifies name and link in string match.
# It is best not to send link with braces here,
# as they will not be stripped
static func identify_link(link: String):
	if (link.find("->") != -1):
		var temp = link.split("->")
		return {"name": temp[0], "link": temp[1]}
	if (link.find("<-") != -1):
		var temp = link.split("<-")
		return {"name": temp[1], "link": temp[0]}
	if (link.find("|") != -1):
		var temp = link.split("|")
		return {"name": temp[0], "link": temp[1]}
	
	return {"name": link, "link": link}

# Simply erases strings. This is the default filter.
static func link_filter_erase(link: RegExMatch):
	return ""

# Replaces links with bbcode urls.
# The displayed text will be equal to link name
# The data will be equal to target passage name
static func link_filter_bbcode(link: RegExMatch):
	var link_id = identify_link(link.get_string(1))
	return "[url=%s]%s[/url]" % [link_id["link"], link_id["name"]]

# Returns passage itself
func get_passage(pid: int):
	if(passages.has(pid)):
		return passages[pid]
	else:
		return {"text": "Error: Passage #"+str(pid)+" not found"}

# Returns passage itself
func get_passage_by_name(name: String):
	for pid in passages:
		if (passages[pid]["name"] == name):
			return passages[pid]
	return {"text": "Error: Passage \""+name+"\" not found"}

# Returns an array of links in string form, "name->link"
# If name IS the link, then just name.
func get_passage_links(passage: Dictionary):
	var result = []
	if (passage.has("links")):
		var links = passage["links"]
		for i in links:
			if (i["name"] == i["link"]):
				result.append(i["name"])
			else:
				result.append(i["name"]+"->"+i["link"])
	return result

func get_passage_names():
	var names = []
	for pid in passages:
		var passage = passages[pid]
		if(passage.has("name")):
			names.append(passage["name"])
		else:
			names.append("Name not found!")
	return names

func has_passage(pid: int):
	return passages.has(pid)

# Returns an Array with all tag strings.
func get_all_tags():
	var result = []
	if (_tag_db_enabled):
		for tag in tag_db:
			result.append(tag)
	else:
		var tags = _construct_tag_db(true)
		for tag in tags:
			result.append(tag)
	return result

# Returns all passage pids which are tagged with this tag.
# If the tag does not exist, empty array is returned.
func get_passages_tagged_with(tag: String):
	if (_tag_db_enabled):
		if (tag_db.has(tag)):
			return tag_db[tag]
		else:
			return []
	else:
		var tags = _construct_tag_db(true)
		if (tags.has(tag)):
			return tags[tag]
		else:
			return []

# Returns a pid
# Returns -1 if starting node not found
func get_starting_node():
	if (data.has("startnode")):
		return int(data["startnode"])
	else:
		return -1

# Returns story name
func get_story_name():
	if (data.has("name")):
		return data["name"]
	else:
		return "Error: Story name not found"


func start():
	self.current_passage_id = get_starting_node()
	self.current_passage = _set_passage(self.current_passage_id)
	return self.current_passage


func traverse(link_ix):
	var next_passage = current_passage.links[link_ix]
	if "pid" in next_passage:
		return traverse_by_passage_id(next_passage.pid)
	else:
		return {}


func traverse_by_passage_id(passage_id):
	if passage_id in _get_reachable_passages():
		return _set_passage(passage_id)
	else:
		push_error(
			"You can't reach passage %s from passage %s".format(
				passage_id,
				current_passage_id
			)
		)
		assert(false)


func _get_reachable_passages():
	var reachable_passages = []
	for link in self.current_passage.links:
		reachable_passages.append(link.pid)
	return reachable_passages


func _set_passage(passage_id):
	self.current_passage_id = passage_id
	self.current_passage = passages[int(current_passage_id)]
	
	return self.current_passage

func is_finished():
	if self.current_passage.has("links") and self.current_passage.links.size() > 0:
		return false
	else:
		return true


func _abort(message="ABORTING DUE TO PROGRAMMING ERROR"):
	push_error(message)
	assert(true)
