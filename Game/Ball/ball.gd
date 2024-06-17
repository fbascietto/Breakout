@tool
class_name Ball

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
	connect("body_entered", Callable(self, "_on_body_entered"))
	paddle = get_parent().get_node("Player")
	paddle.connect('launch_ball', Callable(self, "_on_player_launch_ball"))
	
	# Randomize the initial direction
	var angle = randf_range(0.50, 0.59)
	direction = Vector2(cos(angle), sin(angle)).normalized()
	
func _physics_process(delta):
	if paddle != null && grounded:
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
	launch_ball()

func launch_ball():
	linear_velocity = direction * initial_speed
	position.x = paddle.position.x
	position.y = paddle.position.y - 20 
	grounded = false
	game_started = true

func _on_body_entered(body):
	print(body.name)
	if body.name == "Player":
		var paddle = body as CharacterBody2D
		var hit_pos = position.x - paddle.position.x
		var angle = lerp(-PI / 4, PI / 4, hit_pos / (paddle.size.x / 2))
		linear_velocity = Vector2(cos(angle), -sin(angle)) * linear_velocity.length()
