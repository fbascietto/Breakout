extends CharacterBody2D

signal launch_ball
var game_started = false
var speed = 400
@export var laser_particle_scene: PackedScene
var laser_shooting = false
var laser_shooting_timer = null
var iName = 'Player'

func _ready():
	# Hide lasers initially
	$LaserLeft.hide()
	$LaserRight.hide()
	
func _process(delta):
	if Input.is_action_pressed("start") and !game_started:
		_on_launch_ball()

func _physics_process(delta):
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	 # Calculate the movement based on input
	var movement = Vector2()
	if move_left:
		movement.x -= speed * delta
	if move_right:
		movement.x += speed * delta
	# Update the paddle's position
	move_and_collide(movement)
	
	position.y = 750
	
	# Shoot lasers if active
	if laser_shooting and Time.get_ticks_msec() % 500 < 32:  # Adjust firing rate as needed
		shoot_lasers()

func _on_launch_ball():
	game_started = true
	launch_ball.emit(game_started)

func increase_speed(amount, duration):
	speed += amount
	await get_tree().create_timer(duration)
	speed -= amount

func spawn_extra_ball():
	var ball_scene = preload("../Ball/ball.tscn")
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = position + Vector2(0, -50)  # Adjust as needed
	get_parent().add_child(ball_instance)
	ball_instance.launch_ball()

func activate_lasers(duration):
	laser_shooting = true
	$LaserLeft.show()
	$LaserRight.show()
	await get_tree().create_timer(duration).timeout
	laser_shooting = false
	$LaserLeft.hide()
	$LaserRight.hide()

func shoot_lasers():
	var laser_left = laser_particle_scene.instantiate()
	laser_left.position = $LaserLeft.global_position
	get_parent().add_child(laser_left)

	var laser_right = laser_particle_scene.instantiate()
	laser_right.position = $LaserRight.global_position
	get_parent().add_child(laser_right)
