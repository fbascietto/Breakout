extends CharacterBody2D

@onready var laser_timer = $Timer 

signal launch_ball
@export var laser_particle_scene: PackedScene

var speed = 400
var game_started = false
var laser_shooting = false
var iName = 'Player'

## Debugger
@export var debugger_scene: PackedScene
var debugger_instance: CanvasLayer

func _ready():
	##Debugger
	debugger_instance = debugger_scene.instantiate()
	add_child(debugger_instance)
	# Hide lasers initially
	$LaserLeft.hide()
	$LaserRight.hide()
	
func _process(delta):
	if Input.is_action_pressed("start") and !game_started:
		_on_launch_ball()

func _physics_process(delta):
	# Update the variables to watch
	debugger_instance.set_variable("speed", speed)
	debugger_instance.set_variable("laser timer", laser_timer.wait_time)
	
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
	if laser_shooting and Time.get_ticks_msec() % 500 < 16:  # Adjust firing rate as needed
		shoot_lasers()

func _on_launch_ball():
	game_started = true
	launch_ball.emit(game_started)

func increase_speed(amount, duration) -> void:
	print(amount)
	self.speed += amount
	print(speed)
	await get_tree().create_timer(duration)
	self.speed -= amount

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
	laser_timer.wait_time = duration
	laser_timer.start()
	await laser_timer.timeout
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

func _on_level_1_life_lost():
	var ball_scene = preload("../Ball/ball.tscn")
	var ball_instance = ball_scene.instantiate()
	ball_instance.position = position + Vector2(0, -20)  # Adjust as needed
	get_parent().add_child(ball_instance)
	game_started = false
