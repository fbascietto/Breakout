extends Control

const MAIN_LEVEL = "res://Game/Levels/Level_Placeholder.tscn"
@onready var menu_music_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	menu_music_player.stream.set_loop(true)
	menu_music_player.play()
	grab_focus()

func _on_button_pressed():
	AudioManager.play_sound(AudioManager.BUTTON)
	get_tree().change_scene_to_file(MAIN_LEVEL)
