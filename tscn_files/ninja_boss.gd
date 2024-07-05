extends "res://tscn_files/ninja.gd"
var jump_velocity = 1000
var fly_velocity_x = 500
var fly_velocity_y = -500
var spin_velocity_x = 650
var spin_velocity_y = -650
signal landed
var screen_size
var phase = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$Sprite2D/AnimationPlayer.play("walk")
	if position.x > Global.player_position.x:
		scale.x = -1
		velocity = -1
	else:
		scale.x = 1
		velocity = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Sprite2D/AnimationPlayer.current_animation == "walk":
		$playerdetection.monitoring = true
		speedvar = speed
		position.x += speedvar*velocity*delta
	elif $Sprite2D/AnimationPlayer.current_animation == "spin" and is_jumping:
		speedvar = 300
		y_velocity -= jump_gravity*delta
		position.y -= y_velocity*delta
		if position.y > 468:
			speedvar = speed
			is_jumping = false
			if phase == 1:
				$Sprite2D/AnimationPlayer.play("walk")
			position.y = ground
			landed.emit()
		position.x += speedvar*velocity*delta
	elif $Sprite2D/AnimationPlayer.current_animation == "side_slash":
		speedvar = 1000
		position.x += speedvar*velocity*delta
		pass
	elif $Sprite2D/AnimationPlayer.current_animation == "fly":
		position += Vector2(fly_velocity_x, fly_velocity_y)*delta
		scale.x = (Global.player_position.x - position.x)/abs(Global.player_position.x - position.x)
		if phase == 3:
			$item_timer.stop()
			if position.y > 468:
				landed.emit()
				$item_timer.start()
				position.y = Global.ground
	elif phase == 3 and $Sprite2D/AnimationPlayer.current_animation == "spin":
		position += Vector2(spin_velocity_x, spin_velocity_y)*delta
		scale.x = (Global.player_position.x - position.x)/abs(Global.player_position.x - position.x)
		pass
	position = position.clamp(Vector2.ZERO, screen_size)
	pass

func jump_attack():
	#jump over character and then jump at character
	jump_gravity = 1500
	jump(jump_velocity)
	await landed
	if phase == 1:
		$Sprite2D/AnimationPlayer.play("side_slash")
		sideattack.emit()
		$Sprite2D/AnimationPlayer.queue("walk")
		velocity = (Global.player_position.x - position.x)/abs((Global.player_position.x - position.x))
		scale.x = velocity
	pass

func _on_playerdetection_area_entered(area):
	if phase == 1:
		jump_attack()
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass
	
func _on_area_entered(area):
	$effects.play("flicker")
	health -= 1
	if health == 0:
		$item_timer.stop()
		death(health)
	elif  health < 5:
		phase = 3
		await landed
		spin_velocity_y = -abs(spin_velocity_y)
		$Sprite2D/AnimationPlayer.play("jump")
		$Sprite2D/AnimationPlayer.queue("spin")
	elif health < 10:
		phase = 2
		$playerdetection.monitoring = false
		$Sprite2D/AnimationPlayer.play("fly")
		$item_timer.start()
	pass

func _on_sword_parry():
	parry_health -= 1
	if parry_health <= 0:
		$Sprite2D/AnimationPlayer.clear_queue()
		$Sprite2D/AnimationPlayer.play("stun")
		await get_tree().create_timer(1.0).timeout
		if health > 0 and phase == 1:
			$Sprite2D/AnimationPlayer.play("walk")
	pass
	



func _on_left_area_entered(area):
	velocity = -velocity
	scale.x = -scale.x
	fly_velocity_x = -fly_velocity_x
	spin_velocity_x = -spin_velocity_x
	pass # Replace with function body.


func _on_right_area_entered(area):
	velocity = -velocity
	scale.x = -scale.x
	fly_velocity_x = -fly_velocity_x
	spin_velocity_x = -spin_velocity_x
	pass # Replace with function body.


func _on_top_area_entered(area):
	fly_velocity_y = -fly_velocity_y
	spin_velocity_y = -spin_velocity_y
	pass # Replace with function body.


func _on_bottom_area_entered(area):
	fly_velocity_y = -fly_velocity_y
	spin_velocity_y = -spin_velocity_y
	pass # Replace with function body.


func _on_item_timer_timeout():
	if phase == 2:
		drop_bomb()
	elif phase == 3:
		shuriken_throw()
	pass # Replace with function body.
