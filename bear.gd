extends Area2D
var speed = 525

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*delta
	position.x = clamp(position.x, Global.screen_bounds[0], Global.screen_bounds[1])
	pass


func _on_visible_on_screen_notifier_2d_screen_entered():
	set_process(true)
	$AnimationPlayer.play("run")
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	if area == get_node("/root/Node2D/Player") or area == get_node("/root/Node2D/Player/shield"):
		set_process(false)
		var player = get_node("/root/Node2D/Player")
		player.hide()
		player.death()
		$AnimationPlayer.play("eat")
	pass # Replace with function body.

func stop():
	$AnimationPlayer.play("RESET")
	set_process(false)
	pass
