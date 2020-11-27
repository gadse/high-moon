extends Node

var index_of_current_screen = 0
var current_screen = null

var page_list = []

func _ready():
	self._fill_page_list()
	self._on_next_screen_requested()

func _fill_page_list():
	page_list.append(preload("res://scenes/epilogue/DuelSummary.tscn"))
	match GameState.killed:
		GameState.Npc.SaloonOwnerElizabethParker:
			page_list.append(preload("res://scenes/epilogue/Elizabeth0.tscn"))
			page_list.append(preload("res://scenes/epilogue/Elizabeth1.tscn"))
			page_list.append(preload("res://scenes/epilogue/Elizabeth2.tscn"))
			page_list.append(preload("res://scenes/epilogue/KillerStruckAgain.tscn"))
		GameState.Npc.ScientistAgnesSummerville:
			page_list.append(preload("res://scenes/epilogue/Agnes0.tscn"))
			page_list.append(preload("res://scenes/epilogue/Agnes1.tscn"))
			page_list.append(preload("res://scenes/epilogue/Agnes2.tscn"))
			page_list.append(preload("res://scenes/epilogue/Agnes3.tscn"))
			page_list.append(preload("res://scenes/epilogue/KillerStruckAgain.tscn"))
		GameState.Npc.PriestWilliamPierce:
			page_list.append(preload("res://scenes/epilogue/William0.tscn"))
			page_list.append(preload("res://scenes/epilogue/William1.tscn"))
			page_list.append(preload("res://scenes/epilogue/William2.tscn"))
			page_list.append(preload("res://scenes/epilogue/William3.tscn"))
			page_list.append(preload("res://scenes/epilogue/KillerStruckAgain.tscn"))
		GameState.Npc.SheriffLucasShort:
			page_list.append(preload("res://scenes/epilogue/Lucas0.tscn"))
			page_list.append(preload("res://scenes/epilogue/Lucas1.tscn"))
			page_list.append(preload("res://scenes/epilogue/Lucas2.tscn"))
			page_list.append(preload("res://scenes/epilogue/Lucas3.tscn"))
			page_list.append(preload("res://scenes/epilogue/PeacefulEnding0.tscn"))
			page_list.append(preload("res://scenes/epilogue/PeacefulEnding1.tscn"))
		GameState.Npc.BlacksmithBettyHenderson:
			page_list.append(preload("res://scenes/epilogue/Betty0.tscn"))
			page_list.append(preload("res://scenes/epilogue/Betty1.tscn"))
			page_list.append(preload("res://scenes/epilogue/Betty2.tscn"))
			page_list.append(preload("res://scenes/epilogue/Betty3.tscn"))
			page_list.append(preload("res://scenes/epilogue/Betty4.tscn"))
			page_list.append(preload("res://scenes/epilogue/Betty5.tscn"))
			page_list.append(preload("res://scenes/epilogue/KillerStruckAgain.tscn"))

func _on_next_screen_requested():
	if self._is_next_screen_available():
		self._switch_to_next_screen()
	else:
		queue_free()

func _is_next_screen_available():
	return index_of_current_screen < page_list.size()
	
func _switch_to_next_screen():
	self._show_new_screen()
	index_of_current_screen += 1

func _show_new_screen():
	current_screen = page_list[index_of_current_screen].instance()
	current_screen.connect("tree_exited", self, "_on_next_screen_requested")
	self.add_child(current_screen)
