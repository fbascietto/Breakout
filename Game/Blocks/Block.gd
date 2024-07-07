extends StaticBody2D

signal dead_block

enum PowerUpType {
	SPEED_UP,
	EXTRA_BALL,
	LASER_SHOT
}

# Property to define the block's health
@export var health = 1
@export var power_up_scene: PackedScene
@export var power_up_drop_chance: float = 0.2  # 20% chance
var iName = 'block'

# Load your textures into an array
var textures = [
	preload("res://Art/br1.png"),
	preload("res://Art/br2.png"),
	preload("res://Art/br3.png"),
	preload("res://Art/br4.png"),
	preload("res://Art/br6.png"),
	preload("res://Art/br7.png"),
	preload("res://Art/br9.png"),
	preload("res://Art/br8.png"),
]

func _ready():
	# Set the color of the sprite
	# Randomly select a texture and assign it to the block
	var random_texture = textures[randi() % textures.size()]
	var sprite = self.get_node("Sprite2D") # adjust if the node name is different
	sprite.texture = random_texture

func _on_body_entered(body):
	var chance = randf()
	if body is RigidBody2D or (('iName' in body) and body.iName == 'laser'):
		if chance < power_up_drop_chance:
			var power_up_instance = power_up_scene.instantiate()
			power_up_instance.position = position
			randomize_power_up(power_up_instance)
			get_parent().add_child(power_up_instance)
			
		health -= 1
		if health <= 0:
			dead_block.emit()
			queue_free()  # Remove the block from the scene

func randomize_power_up(power_up_instance):
	var power_up_type = randi() % PowerUpType.values().size()
	power_up_instance.set_power_up_type(power_up_type)
