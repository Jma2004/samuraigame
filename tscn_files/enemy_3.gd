extends "res://tscn_files/enemy_2.gd"
@export var dash_back := -700
@export var dash_ahead := 750


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerpos = get_tree().get_first_node_in_group("player").position.x
	if $Sprite2D/AnimationPlayer.current_animation == "walk":
		$playerdetection.monitoring = true
		if (playerpos < position.x):
			scale.x = -1
			velocity = -1
		if (playerpos > position.x):
			scale.x = 1
			velocity = 1
		speedvar = speed
		position.x += speedvar*velocity*delta
	elif $Sprite2D/AnimationPlayer.current_animation == "dash_back":
		if (playerpos < position.x):
			position.x -= dash_back*delta
		if (playerpos > position.x):
			position.x += dash_back*delta
	elif $Sprite2D/AnimationPlayer.current_animation == "dash_ahead":
		$playerdetection.monitoring = false
		if (playerpos < position.x):
			position.x -= dash_ahead*delta
		if (playerpos > position.x):
			position.x += dash_ahead*delta
	position.x = clamp(position.x, Global.screen_bounds[0], Global.screen_bounds[1])
	pass
	


func death():
	$sword.disconnect("parry", _on_sword_parry)
	$playerdetection.monitoring = false
	set_process(false)
	$Sprite2D/AnimationPlayer.clear_queue()
	enemydeath.emit()
	speedvar = 0
	$Sprite2D/AnimationPlayer.play("death")
	await $Sprite2D/AnimationPlayer.animation_finished
	queue_free()
	pass

	
func _on_playerdetection_area_entered(area):
	if area == get_node("/root/Node2D/Player") or area == get_node("/root/Node2D/Player/shield"):
		jumpattack()
	pass

func jumpattack():
	$Sprite2D/AnimationPlayer.play("dash_back")
	$Sprite2D/AnimationPlayer.queue("dash_ahead")
	$Sprite2D/AnimationPlayer.queue("walk")
	pass
