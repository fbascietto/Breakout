extends StaticBody2D


signal dead_block

enum PowerUpType {
	SPEED_UP,
	EXTRA_BALL,
	LASER_SHOT
}

# Property to define the block's health
@export var health = 1
@export var color : Color = Color(1, 1, 1)  # Default white color
@export var power_up_scene: PackedScene
@export var power_up_drop_chance: float = 0.2  # 20% chance
var iName = 'block'

func _ready():
	# Set the color of the sprite
	$Sprite2D.modulate = color  # Assuming you have a Sprite2D node
	 # Connect the body_entered signal to handle collisions
	$CollisionShape2D.connect("body_entered", Callable(self, "_on_body_entered"))

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
