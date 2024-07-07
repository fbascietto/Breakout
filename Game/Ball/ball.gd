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

# Minimum angle from vertical to avoid wall-to-wall bounces
const MIN_ANGLE_FROM_VERTICAL = 15.0

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
			adjust_exit_angle()
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

func _on_body_entered(_body):
	AudioManager.play_sound(AudioManager.HIT)

func _on_area_2d_area_entered(area):
	AudioManager.play_sound(AudioManager.HIT)
	if area.name == "Wall":
		adjust_exit_angle()
		
	if area.name == "Player":
		var hit_pos = position.x - paddle.position.x
		var size = paddle.get_node("Sprite2D").texture.get_size()
		var angle = lerp(-PI / 4, PI / 4, hit_pos / (size.x / 2))
		linear_velocity = Vector2(cos(angle), -sin(angle)) * linear_velocity.length()

func adjust_exit_angle():
	var angle_from_vertical = abs(direction.angle_to(Vector2.UP))
	if angle_from_vertical < deg_to_rad(MIN_ANGLE_FROM_VERTICAL) or angle_from_vertical > PI - deg_to_rad(MIN_ANGLE_FROM_VERTICAL):
		if direction.y > 0:
			direction = Vector2(direction.x, -sin(deg_to_rad(MIN_ANGLE_FROM_VERTICAL))).normalized()
		else:
			direction = Vector2(direction.x, sin(deg_to_rad(MIN_ANGLE_FROM_VERTICAL))).normalized()
