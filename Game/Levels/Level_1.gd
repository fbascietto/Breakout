extends Node2D

@export var block_scene : PackedScene
var starting_corner: Vector2 = Vector2(40,86)
var q_blocks

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_blocks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	q_blocks = get_children().filter(func(child): return child is StaticBody2D).size()

func setup_blocks():
	var rows = 10
	var cols = 16
	var block_size = Vector2(48, 32)  # Adjust based on your block's size
	var colors = [
		Color(1, 0, 0),  # Red
		Color(0, 1, 0),  # Green
		Color(0, 0, 1),  # Blue
		Color(1, 1, 0),  # Yellow
		Color(1, 0, 1)   # Magenta
	]

	for row in range(rows):
		for col in range(cols):
			var block = block_scene.instantiate() as StaticBody2D
			block.position = starting_corner + Vector2((col * block_size.x) /1.365, (row * block_size.y) /2)
			block.color = colors[row % colors.size()]  # Assign a color based on the row
			add_child(block)
