extends Node2D
var current_scene = null
var current_path
# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Global.player_died.connect(_on_player_death)
	current_scene = get_child(0)
	pass # Replace with function body.


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	current_path = path
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	var next_button = current_scene.get_child(current_scene.get_child_count() - 1)
	next_button.next_pressed.connect(_on_next_button_next_pressed)


func _on_next_button_next_pressed(next_scene):
	Global.screen_bounds = [0, 1142]
	goto_scene(next_scene)
	if get_tree().paused:
		get_tree().paused = false
	pass # Replace with function body.

func _on_player_death():
	goto_scene("res://tscn_files/option_screen.tscn")
	Global.player_health = 5
	pass
	
func reset():
	call_deferred("deferred_reset")
	pass	
func deferred_reset():
	current_scene.free()
	get_tree().reload_current_scene()
	Global.reset_variables()


