extends Node2D

const MAIN_LEVEL = "res://Game/landing.tscn"

signal life_lost
 
@export var block_scene : PackedScene
@export var lives = 3

@onready var lose_message : Control = $LosingLayout
@onready var win_message : Control = $WinningLayout

var starting_corner: Vector2 = Vector2(48,86)

var score = 0
var q_blocks
var q_balls 

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_blocks()
	
func _process(delta):
	q_blocks = get_children().filter(func(child): return child is StaticBody2D).size()
	q_balls = get_children().filter(func(child): return child is Ball).size()

	if winning_condition():
		show_next_level_prompt()
	
	if losing_condition():
		lives -= 1
		if lives > 0:
			$Lives.text = "Lives: %s" % lives
			life_lost.emit()
		else:
			Engine.time_scale = 0
			lose_message.visible = true
	
func setup_blocks():
	var rows = 4
	var cols = 17
	var block_size = Vector2(70, 45)  # Adjust based on your block's size
	var colors = [
		Color(1, 0, 0),  # Red
		Color(0, 1, 0),  # Green
		Color(0, 0, 1),  # Blue
		Color(1, 1, 0),  # Yellow
		Color(1, 0, 1),   # Magenta
		Color(0.5, 0.5, 0.3) 
	]

	for row in range(rows):
		for col in range(cols):
			var block = block_scene.instantiate() as StaticBody2D
			block.connect("dead_block", Callable(self, "_on_dead_block"))
			block.position = starting_corner + Vector2((col * block_size.x) /2.2, (row * block_size.y) /3)
			block.color = colors[row % colors.size()]  # Assign a color based on the row
			add_child(block)

func winning_condition():
	return q_blocks == 0
	
func losing_condition():
	return q_balls == 0
	
func show_next_level_prompt():
	# Freeze the game
	Engine.time_scale = 0
	win_message.visible = true

func _on_area_2d_body_entered(body):
	if body is Ball:
		body.queue_free()

func _on_try_again_pressed():
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_next_level_pressed():
	Engine.time_scale = 1
	get_tree().change_scene_to_file(MAIN_LEVEL)

func _on_dead_block():
	score += 10
	$Score.text = "Score: %s" % score
