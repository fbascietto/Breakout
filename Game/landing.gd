extends Control

const MAIN_LEVEL = "res://Game/Levels/Level_Placeholder.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()

func _on_button_pressed():
	get_tree().change_scene_to_file(MAIN_LEVEL)
