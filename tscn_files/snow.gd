extends Sprite2D
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Node2D/Player")
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(false)
	$AnimationPlayer.play("gentle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player.position.x -= 100*delta
	pass


func _on_animation_player_animation_started(anim_name):
	if anim_name == "blizzard":
		set_process(true)
	elif anim_name == "gentle":
		set_process(false)
	pass # Replace with function body.
