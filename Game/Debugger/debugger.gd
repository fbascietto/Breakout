extends CanvasLayer

@export var variables_to_watch = {}

func _ready():
	update_display()

func _process(delta):
	update_display()

func set_variable(name: String, value):
	variables_to_watch[name] = value
	update_display()

func update_display():
	var display_text = ""
	for name in variables_to_watch.keys():
		# print("User {id} is {name}.".format({"id": 42, "name": "Godot"}))
		display_text += "{name}: {variable}\n".format({"name": name,"variable": variables_to_watch[name]})
	$Label.text = display_text
