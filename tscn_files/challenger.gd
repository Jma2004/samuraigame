extends Area2D
var speed = 25
var health = 33
var attacks = ["up_slash", "down_slash", "side_slash"]
signal died
signal hit
signal player_parry
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $body/AnimationPlayer.current_animation == "walk":
		position.x += scale.x*speed*delta
	position.x = clamp(position.x, Global.screen_bounds[0], Global.player_position.x - 75)
	pass



func _on_area_entered(area):
	$effects.play("flicker")
	health -= 1
	hit.emit()
	if health == 0:
		death()
	pass # Replace with function body.
	
func attack(attackstring):
	if attackstring == "up_slash":
		$Sprite2D/AnimationPlayer.play("downshine")
	elif attackstring == "down_slash":
		$Sprite2D/AnimationPlayer.play("upshine")
	elif attackstring == "side_slash":
		$Sprite2D/AnimationPlayer.play("middleshine")
	$arm/AnimationPlayer.play(attackstring)
	$arm/AnimationPlayer.queue("RESET")
	pass

func death():
	died.emit()
	$body/AnimationPlayer.play("death")
	set_process(false)
	$attack_timer.stop()
	set_deferred("monitoring", false)
	pass


func _on_sword_parry():
	$attack_timer.stop()
	$arm/AnimationPlayer.play("RESET")
	$body/AnimationPlayer.play("stunned")
	$shield.turn_off()
	await get_tree().create_timer(1).timeout
	if health > 0:
		attack(attacks.pick_random())
		$body/AnimationPlayer.play("walk")
		$shield.shield_health = 1
		$shield.turn_on()
		$attack_timer.start()
	pass # Replace with function body.


func _on_shield_area_entered(area):
	player_parry.emit()
	await get_tree().create_timer(1).timeout
	if health > 0:
		$shield.shield_health = 1
		$shield.update_shield()
	pass # Replace with function body.


func _on_attack_timer_timeout():
	attack(attacks.pick_random())
	pass # Replace with function body.


func _on_hud_start_game():
	$arm/AnimationPlayer.play("side_slash")
	await get_tree().create_timer(2).timeout
	$body/AnimationPlayer.play("walk")
	$arm/AnimationPlayer.play("RESET")
	$attack_timer.start()
	pass # Replace with function body.
