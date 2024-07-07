extends Node2D

signal life_lost
 
@export var block_scene : PackedScene
@export var lives = 3

@onready var lose_message : Control = $LosingLayout
@onready var win_message : Control = $WinningLayout
@onready var music_player = $LevelMusic

var backgroundArray = [ 
	preload("res://Art/Green.png"),
	preload("res://Art/Yellow.png"),
	preload("res://Art/Blue.png"),
	preload("res://Art/Gray.png"), 
]

var starting_corner: Vector2 = Vector2(48,150)

var q_blocks
var q_balls 

func _ready():
	$Background.texture = backgroundArray[0]
	music_player.stream.set_loop(true)
	music_player.play()
	setup_blocks()
	
func _process(_delta):
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
			music_player.stop()
			AudioManager.play_sound(AudioManager.LOSE)
			Engine.time_scale = 0
			lose_message.visible = true
	
func setup_blocks():
	$Background.texture = backgroundArray[Global.current_level]
	var rows = Global.level_data.num_rows
	var cols = 18
	var block_size = Vector2(70, 60)  # Adjust based on your block's size
	
	if(Global.score > 0):
		update_score()

	for row in range(rows):
		for col in range(cols):
			var block = block_scene.instantiate() as StaticBody2D
			block.connect("dead_block", Callable(self, "_on_dead_block"))
			block.position = starting_corner + Vector2((col * block_size.x) /2.3, (row * block_size.y) / 4)
			add_child(block)

func winning_condition():
	return q_blocks == 0
	
func losing_condition():
	return q_balls == 0
	
func show_next_level_prompt():
	music_player.stop()
	AudioManager.play_sound(AudioManager.WIN)
	# Freeze the game
	Engine.time_scale = 0
	win_message.visible = true

func _on_area_2d_body_entered(body):
	if body is Ball:
		body.queue_free()

func _on_try_again_pressed():
	Global.score = 0
	update_score()
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_next_level_pressed():
	win_message.visible = false
	Engine.time_scale = 1
	Global.next_level()
	get_tree().reload_current_scene()

func _on_dead_block():
	Global.add_score()
	update_score()

func update_score():
	$Score.text = "Score: %s" % Global.score
