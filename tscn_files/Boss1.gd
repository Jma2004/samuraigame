extends base_enemy
var attack_variable = 1
signal hit_wall
signal boss_death
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = 0
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*velocity*delta
	position.x = clamp(position.x, Global.screen_bounds[0], Global.screen_bounds[1])
	if velocity != 0:
		$AnimationPlayerBody.play("enemywalk")
	pass
	

func attack(attacktype):
	if attacktype == "upslash":
		upattack.emit()
		$AnimationPlayerArm.play("enemyupslash")
	elif attacktype == "downslash":
		downattack.emit()
		$AnimationPlayerArm.play("enemydownslash")

func _on_timer_timeout():
	attack_variable *= -1
	if attack_variable == 1:
		attack("upslash")
	elif attack_variable == -1:
		attack("downslash")

func death():
	$Parrytimer.stop()
	$Parrytimer.disconnect("countdown", _on_parrytimer_countdown)
	$AnimationPlayerBody.play("enemydeath")
	$AnimationPlayerArm.stop()
	set_process(false)
	$Timer.stop()
	enemydeath.emit()
	boss_death.emit()
	await $AnimationPlayerBody.animation_finished
	queue_free()

func _on_sword_parry():
	$Parrytimer.start()
	$Timer.stop()

func _on_parrytimer_countdown():
	$AnimationPlayerBody.play("parry")
	velocity = 0
	pass # Replace with function body.
	
func _on_parrytimer_timeout():
	$Timer.start()
	if scale.x == -1:
		velocity = -1
	if scale.x == 1:
		velocity = 1

func _on_downattack():
	$ShineEffect/AnimationPlayer.play("upshine")
	pass # Replace with function bo
	
func _on_upattack():
	$ShineEffect/AnimationPlayer.play("downshine")
	pass # Replace with function body.
	

func _on_sideattack():
	$ShineEffect/AnimationPlayer.play("middleshine")
	pass # Replace with function body.


func _on_leftdetect_area_entered(area):
	velocity = 1
	scale.x = 1
	pass # Replace with function body.


func _on_rightdetect_area_entered(area):
	velocity = -1
	scale.x = -1
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.start()
	set_process(true)
	velocity = (Global.player_position.x - position.x)/abs(Global.player_position.x - position.x)
	pass
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass
