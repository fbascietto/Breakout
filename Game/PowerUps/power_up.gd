extends Area2D

@export var fall_speed: float = 200.0

#sprites
@export var speed_up_sprite: Texture2D
@export var extra_ball_sprite: Texture2D
@export var laser_shot_sprite: Texture2D

#laser parameters
@export var laser_duration: float = 10.0

#speed parameters
@export var speed_increase: int = 500
@export var duration: int = 10
	
var power_up_type: int

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	position.y += fall_speed * delta
	
func _on_body_entered(body):
	if body.name == "Player":
		apply_power_up(body)
		queue_free()

func apply_power_up(player):
	match power_up_type:
		0:
			player.speed_powerup_go(500)
		1:
			player.spawn_extra_ball()
		2:
			player.activate_lasers(laser_duration)


func set_power_up_type(type):
	power_up_type = type
	set_type()

func set_type():
	var sprite = $Sprite2D
	match power_up_type:
		0:
			sprite.texture = speed_up_sprite
		1:
			sprite.texture = extra_ball_sprite
		2:
			sprite.texture = laser_shot_sprite
