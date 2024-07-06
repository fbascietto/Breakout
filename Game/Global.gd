extends Node

@export var current_level: int = 1
const MAIN_LEVEL = "res://Game/landing.tscn"
var level_data: Resource
var score: int

func _ready():
	load_level_data()

func load_level_data():
	var level_path = "res://Game/Levels/LevelInfo/Level" + str(current_level) + ".tres"
	if ResourceLoader.exists(level_path):
		level_data = ResourceLoader.load(level_path)
	else:
		print("Level file not found: " + level_path)
		level_data = null

func next_level():
	current_level += 1
	
	if(current_level > 3):
		get_tree().change_scene_to_file(MAIN_LEVEL)
	
	load_level_data()

func add_score():
	score += 10
