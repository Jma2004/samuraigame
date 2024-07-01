extends Area2D
@export var speed = 200
var dash_speed = 600
var velocity = Vector2.ZERO
@export var is_attacking = false
#direction: true is right, false is left
var direction = true
var screensize
signal upattack
signal downattack
signal sideattack
signal is_dead
# Called when the node enters the scene tree for the first time.
func _ready():
	speed += 25*Global.player_speed
	dash_speed += 50*Global.player_speed
	screensize = get_viewport_rect().size
	$shield.shield_health = Global.player_shield
	$shield.update_shield()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	var dash_velocity = Vector2.ZERO
	if $AnimationPlayer.current_animation == "walk":
		if direction:
			velocity.x = speed
			scale = Vector2(1, 1)
		else:
			velocity.x = -speed
			scale = Vector2(-1, 1)
		if $shield.shield_health == 0 and !$shield/AnimationPlayer.is_playing():
			$CollisionShape2D.disabled = false
	elif $AnimationPlayer.current_animation == "jumpahead":
		if !direction:
			dash_velocity.x = -dash_speed
		else:
			dash_velocity.x = dash_speed
		if $AnimationPlayer.current_animation_position > 0.1 and $AnimationPlayer.current_animation_position < 0.3:
			if $shield.shield_health == 0:
				$CollisionShape2D.disabled = true
	position += velocity*delta 
	position += dash_velocity * delta
	position.x = clamp(position.x, Global.screen_bounds[0], Global.screen_bounds[1])
	Global.player_position = position
	death(Global.player_health)
	
func _input(event):
	if Input.is_action_just_pressed("move_left"):
		$AnimationPlayer.play("walk")
		direction = false
	if Input.is_action_just_pressed("move_right"):
		$AnimationPlayer.play("walk")
		direction = true
	if !is_attacking:
		if Input.is_action_just_pressed("dash"):
			$AnimationPlayer.play("jumpahead")
			$AnimationPlayer.queue("walk")
		if Input.is_action_just_pressed("downattack"):
			$AnimationPlayer.play("down_slash")
			$shine_effect/AnimationPlayer.play("upshine")
			$AnimationPlayer.queue("walk")
		if Input.is_action_just_pressed("upattack"):
			$AnimationPlayer.play("up-slash")
			$shine_effect/AnimationPlayer.play("downshine")
			$AnimationPlayer.queue("walk")
		if Input.is_action_just_pressed("rightattack"):
			scale = Vector2(1, 1)
			$AnimationPlayer.play("side-slash")
			$shine_effect/AnimationPlayer.play("middleshine")
			$AnimationPlayer.queue("walk")
		if Input.is_action_just_pressed("leftattack"):
			scale = Vector2(-1, 1)
			$AnimationPlayer.play("side-slash")
			$shine_effect/AnimationPlayer.play("middleshine")
			$AnimationPlayer.queue("walk")
	if event is InputEventScreenTouch:
		if event.double_tap:
			$AnimationPlayer.play("jumpahead")
			$AnimationPlayer.queue("walk")
		elif event.pressed:
			if event.position > screensize/2:
				direction = true
			if event.position < screensize/2:
				direction = false
			$AnimationPlayer.play("walk")

	if event is InputEventScreenDrag:
		if event.relative.y > 50:
			$AnimationPlayer.play("down_slash")
			$shine_effect/AnimationPlayer.play("upshine")
			$AnimationPlayer.queue("walk")
		elif event.relative.y < -50:
			$AnimationPlayer.play("up-slash")
			$shine_effect/AnimationPlayer.play("downshine")
			$AnimationPlayer.queue("walk")
		elif event.relative.x > 50:
			scale = Vector2(1, 1)
			$AnimationPlayer.play("side-slash")
			$shine_effect/AnimationPlayer.play("middleshine")
			$AnimationPlayer.queue("walk")
		elif event.relative.x < -50:
			scale = Vector2(-1, 1)
			$AnimationPlayer.play("side-slash")
			$shine_effect/AnimationPlayer.play("middleshine")
			$AnimationPlayer.queue("walk")

func _on_area_entered(area):
	Global.player_health -= 1
	$effects.play("flicker")
#	if speed > 200:
#		speed -= 50
#		$AnimationPlayer.speed_scale -= 0.5
#		dash_speed -= 50
		
func death(health_number : int):
	if health_number == 0:
		$AnimationPlayer.play("death")
		set_process(false)
		set_process_input(false)
		is_dead.emit()
			


func _on_timer_countdown():
	is_attacking = true
	pass # Replace with function body.

func _on_timer_timeout():
	is_attacking = false
	pass # Replace with function body.

#func _on_attack_parry():
##	if speed < 450:
##		speed += 50
##		dash_speed += 50
##		$AnimationPlayer.speed_scale += 0.5
#	pass # Replace with function body.


func _on_stunplayer():
	if direction:
		position.x -= 25
	else:
		position.x += 25
	$AnimationPlayer.play("stunned")
	set_process_input(false)
	await get_tree().create_timer(0.5).timeout
	set_process_input(true)
	pass # Replace with function body.

