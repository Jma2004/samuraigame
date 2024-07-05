extends "res://tscn_files/enemy_3.gd"
var is_jumping = false
@export var jump_gravity = 600
var initial_velocity = 200
var y_velocity
@export var ground := 468
var shuriken = preload("res://tscn_files/shuriken.tscn")
var bomb = preload("res://tscn_files/bomb.tscn")
signal throw_shuriken(item, direction, location)
signal throw_bomb(item, location)
func _ready():
	if position.y < Global.ground or position.x == Global.player_position.x:
		jump(initial_velocity)
	else:
		$Sprite2D/AnimationPlayer.play("walk")
	if position.x >= Global.player_position.x:
		scale.x = -1
		velocity = -1
	elif position.x <= Global.player_position.x:
		scale.x = 1
		velocity = 1
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Sprite2D/AnimationPlayer.current_animation == "walk":
		$playerdetection.monitoring = true
		speedvar = speed
	elif is_jumping:
		y_velocity -= jump_gravity*delta
		position.y -= y_velocity*delta
		if position.y > 468:
			speedvar = speed
			is_jumping = false
			$Sprite2D/AnimationPlayer.play("walk")
			position.y = ground
	position.x += speedvar*velocity*delta
	pass

func _on_playerdetection_area_entered(area):
	speedvar = 700
	jump(initial_velocity)
	pass

func shuriken_throw():
	var direction = Vector2(Global.player_position- position).normalized()
	throw_shuriken.emit(shuriken, direction, position)
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
#	if position.x < Global.player_position.x:
#		scale.x = 1
#		velocity = 1
#	else:
#		scale.x = -1
#		velocity = -1
	queue_free()
	pass # Replace with function body.


func death(health_counter):
	if health_counter == 0:
		$sword.disconnect("parry", _on_sword_parry)
		$playerdetection.monitoring = false
		set_process(false)
		position.y = Global.ground
		$Sprite2D/AnimationPlayer.clear_queue()
		enemydeath.emit()
		speedvar = 0
		$Sprite2D/AnimationPlayer.play("death")
		await $Sprite2D/AnimationPlayer.animation_finished
		queue_free()
	pass

func jump(jump_velocity):
	$Sprite2D/AnimationPlayer.play("jump")
	is_jumping = true
	y_velocity = jump_velocity
	$Sprite2D/AnimationPlayer.queue("spin")
	pass

func drop_bomb():
	throw_bomb.emit(bomb, position)
	pass
