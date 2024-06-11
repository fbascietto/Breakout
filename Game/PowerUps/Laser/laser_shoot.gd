extends Area2D

@export var speed: float = 400.0
var iName = 'laser'

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	position.y -= speed * delta
	if position.y < 0:
		queue_free()

func _on_body_entered(body):
	if ('iName' in body) and body.iName == "block":
		body._on_body_entered(self)
		queue_free()
