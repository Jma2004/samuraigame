extends Button
signal next_pressed(next_scene)
@export var next_scene := "path"
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_pressed():
	next_pressed.emit(next_scene)
	pass # Replace with function body.
