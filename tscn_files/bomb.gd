extends Area2D
var falling_speed := 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y < Global.ground + 82:
		position.y += falling_speed*delta
	pass


func _on_area_entered(area):
	$AnimationPlayer.play("defused")
	await $AnimationPlayer.animation_finished
	queue_free()
	pass # Replace with function body.


func _on_animation_player_animation_finished(explosion):
	queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_entered():
	$AnimationPlayer.play("ticking")
	$AnimationPlayer.queue("explosion")
	pass # Replace with function body.
