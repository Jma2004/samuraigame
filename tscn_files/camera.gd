extends Camera2D
@export var camera_speed = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.checkpoint_reached:
		position.x = get_parent().checkpoint_position - 576
		reset_smoothing()
		align()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Global.player_position.x > get_screen_center_position().x):
		position.x = Global.player_position.x - 576
	position.x += camera_speed*delta
	Global.screen_bounds = [get_screen_center_position().x - 576, get_screen_center_position().x + 576]
	pass


func _on_player_is_dead():
	set_process(false)
	pass # Replace with function body.


func _on_node_2d_game_start():
	set_process(true)
	pass # Replace with function body.
