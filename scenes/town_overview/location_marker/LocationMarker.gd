extends Area2D

signal clicked(dialog_scene)

export(String, FILE) var character_icon
export(PackedScene) var dialog_scene

func _ready():
	$Sprite.texture = load(character_icon)

func _on_LocationMarker_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("clicked", dialog_scene)


func _on_LocationMarker_mouse_entered():
	self.scale.x = 1.2
	self.scale.y = 1.2

func _on_LocationMarker_mouse_exited():
	self.scale.x = 1
	self.scale.y = 1
