extends Area2D
@export var shield = 0
signal stun_player
signal enemydeath
@export var shuriken_state = false
signal hit
var shuriken = preload("res://tscn_files/shuriken.tscn")
var blade_beam = preload("res://tscn_files/blade_beam.tscn")
@export var attacking = false
var jump_speed = 1000
@export var walk_speed = 100
signal throw_shuriken(item, direction, location)
var attacks = ["upslash", "downslash", "sideslash"]
var health = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	if shield != 0:
		$shield.shield_health = shield
		$shield.update_shield()
	if attacking:
		$attacks.play("idle")
		$Timer.stop()
	else:
		$Timer.start()
		set_collision_mask_value(2, false)
		$player_detection.monitoring = false
		$sword.monitorable = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $attacks.current_animation == "idle":
		position.x += delta*walk_speed
		scale.x = (Global.player_position.x - position.x)/abs(Global.player_position.x - position.x)
		pass
	elif  $attacks.current_animation == "dash_attack":
		position.x += scale.x*jump_speed*delta
		monitoring = false
		$shield.monitoring = false
		pass
	elif $attacks.current_animation == "jump_back":
		position.x += -scale.x*jump_speed*delta
		monitoring = false
		$shield.monitoring = false
		pass
	position.x = clamp(position.x, Global.screen_bounds[0] + 100, Global.screen_bounds[1] - 100)
	pass


func _on_sword_parry():
	if !attacking:
		$Timer.stop()
		$Sprite2D/AnimationPlayer.play("stun")
		$shield.turn_off()
		await get_tree().create_timer(1.0).timeout
		$Timer.start()
		$shield.update_shield()
	else:
		var temp_health = health
		$attacks.play("parry")
		$shield.turn_off()
		await $attacks.animation_finished
		if health != 0:
			$shield.update_shield()
			if health == temp_health:
				scale.x *= -1
				$attacks.play("jump_back")
		pass
	pass # Replace with function body.


func _on_timer_timeout():
	var strings = ["upslash", "downslash", "sideslash"]
	$Sprite2D/AnimationPlayer.play(strings.pick_random())
	$Sprite2D/AnimationPlayer.queue("RESET")
	if $Sprite2D/AnimationPlayer.current_animation == "upslash":
		$shine_effect/AnimationPlayer.play("downshine")
	elif $Sprite2D/AnimationPlayer.current_animation == "downslash":
		$shine_effect/AnimationPlayer.play("upshine")
	elif $Sprite2D/AnimationPlayer.current_animation == "sideslash":
		$shine_effect/AnimationPlayer.play("middleshine")
		
	if $shield.shield_health != shield:
		$shield.shield_health = shield
		$shield.update_shield()
	
	if shuriken_state:
		var direction = Vector2(Global.player_position- position).normalized()
		throw_shuriken.emit(shuriken, direction, position)
	pass # Replace with function body.

func attack(attackstring):
	if attackstring == "upslash":
		$shine_effect/AnimationPlayer.play("downshine")
		$attacks.play("up_slash")
	elif attackstring == "downslash":
		$shine_effect/AnimationPlayer.play("upshine")
		$attacks.play("down_slash")
	elif attackstring == "sideslash":
		$shine_effect/AnimationPlayer.play("middleshine")
		$attacks.play("side_slash")
	$attacks.queue("idle")
	pass


func _on_shield_area_entered(area):
	stun_player.emit()
	if attacking:
		$attacks.play("dash_attack")
	pass # Replace with function body.


func _on_player_detection_area_entered(area):
	attack(attacks.pick_random())
	$idle_timer.stop()
	walk_speed *= -scale.x
	pass # Replace with function body.


func _on_idle_timer_timeout():
	if randi() % 2 == 0:
		$attacks.play("blade_beam")
		await get_tree().create_timer(0.7).timeout
		throw_shuriken.emit(blade_beam, scale.x, position + Vector2(scale.x*150, 0))
		$shield.turn_off()
		$attacks.queue("idle")
	else:
		$attacks.play("charge_up")
	
	pass # Replace with function body.


func _on_attacks_animation_finished(anim_name):
	if anim_name == "jump_back" or anim_name == "dash_attack":
		$shield.shield_health = 1
		$shield.update_shield()
		$attacks.play("idle")
	if anim_name == "hit" and health > 0:
		$shield.shield_health = 1
		$shield.update_shield()
	pass # Replace with function body.


func _on_attacks_animation_started(anim_name):
	if anim_name == "idle":
		$idle_timer.start()
		$shield.update_shield()
	pass # Replace with function body.


func _on_area_entered(area):
	$effects.play("flicker")
	health -= 1
	hit.emit()
	if health == 0:
		death()
	else:
		$attacks.play("hit")
		$idle_timer.stop()
		await $attacks.animation_finished
		scale.x *= -1
		$attacks.play("jump_back")
		$attacks.queue("idle")
	pass # Replace with function body.

func death():
	enemydeath.emit()
	$idle_timer.stop()
	set_process(false)
	$attacks.play("death")
	pass


func _on_area_2d_area_entered(area):
	$shine_effect/AnimationPlayer.play("middleshine")
	$attacks.play("dash_attack")
	pass # Replace with function body.
