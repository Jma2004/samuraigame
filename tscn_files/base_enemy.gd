extends Area2D
class_name base_enemy
@export var attackstring := "upslash"
@export var health := 1
@export var speed := 200
var speedvar = speed
var velocity := -1
signal upattack
signal downattack
signal sideattack
var playerpos
signal enemydeath
var speedscale
# Called when the node enters the scene tree for the first time.
func _ready():
	speed *= speedscale
	$AnimationPlayer.speed_scale = speedscale
	$AnimationPlayer.play("enemywalk")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerpos = get_tree().get_first_node_in_group("player").position.x
	death(health)
	position.x += speedvar*velocity*delta
	if $AnimationPlayer.current_animation == "enemywalk":
		if (playerpos < position.x):
			scale.x = -1
			velocity = -1
		if (playerpos > position.x):
			scale.x = 1
			velocity = 1
		speedvar = speed
	pass

func _on_area_entered(area):
	$effects.play("flicker")
	if health != 0:
		health -= 1

func _on_sword_parry():
	$AnimationPlayer.play("parry")
	$AnimationPlayer.queue("enemywalk")
	pass
func death(health_counter):
	if health_counter == 0:
		$sword.disconnect("parry", _on_sword_parry)
		set_process(false)
		$AnimationPlayer.clear_queue()
		enemydeath.emit()
		$playerdetection.monitoring = false
		speedvar = 0
		$AnimationPlayer.play("enemydeath")
		await $AnimationPlayer.animation_finished
		queue_free()
			

func attack(attacktype):
	speedvar = 0
	if attacktype == "upslash":
		$shine_effect/AnimationPlayer.play("downshine")
		$AnimationPlayer.play("enemyupslash")
		upattack.emit()
	elif attacktype == "downslash":
		$shine_effect/AnimationPlayer.play("upshine")
		$AnimationPlayer.play("enemydownslash")
		downattack.emit()
	elif attacktype == "sideslash":
		$shine_effect/AnimationPlayer.play("middleshine")
		$AnimationPlayer.play("enemysideslash")
		sideattack.emit()
	$AnimationPlayer.queue("RESET")


func _on_playerdetection_area_entered(area):
	if $playerdetection.has_overlapping_areas():
		attack(attackstring)
	pass # Replace with function body.


func _on_playerdetection_area_exited(area):
	$AnimationPlayer.queue("enemywalk")
	pass # Replace with function body.


func _on_downattack():
#	await $AnimationPlayer.current_animation_position == 0.3
#	$shine_effect/AnimationPlayer.play("upshine")
	pass # Replace with function body.


func _on_sideattack():
#	await $AnimationPlayer.current_animation_position == 0.3
#	$shine_effect/AnimationPlayer.play("middleshine")
	pass # Replace with function body.


func _on_upattack():
#	await $AnimationPlayer.current_animation_position == 0.3
#	$shine_effect/AnimationPlayer.play("downshine")
	pass # Replace with function body.



