extends RigidBody2D

# Variables for ball speed and direction
var iName = 'ball'
var initial_speed = 250
var direction = Vector2()
var colliding = false
var grounded = true
var game_started = false
var paddle = null

func _ready():
	paddle = get_parent().get_node("Player")
	# Randomize the initial direction
	var angle = randf_range(0.50, 0.59)
	direction = Vector2(cos(angle), sin(angle)).normalized()
	
func _physics_process(delta):
	if grounded:
		position.x = paddle.position.x
	
	if game_started:
		# Keep applying the velocity to ensure constant movement
		linear_velocity = direction * initial_speed

		var collision_info = move_and_collide(linear_velocity * delta)
		if collision_info and not colliding:
			direction = direction.bounce(collision_info.get_normal()) 
			colliding = true
		else:
			colliding = false

func _on_player_launch_ball(value):
	grounded = !value
	game_started = value

func launch_ball():
	direction = Vector2(1,-1)
	grounded = false
	game_started = true
