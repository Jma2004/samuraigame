extends Area2D
class_name base_enemy
var attacks = ["upslash", "downslash", "sideslash"]
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
var speedscale := 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	attackstring = attacks[randi_range(0, 2)]
	speed *= speedscale
	$Sprite2D/AnimationPlayer.speed_scale = speedscale
	$Sprite2D/AnimationPlayer.play("walk")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerpos = get_tree().get_first_node_in_group("player").position.x
	position.x += speedvar*velocity*delta
	if $Sprite2D/AnimationPlayer.current_animation == "walk":
		if (playerpos < position.x):
			scale.x = -1
			velocity = -1
		if (playerpos > position.x):
			scale.x = 1
			velocity = 1
		speedvar = speed
		position.x = clamp(position.x, Global.screen_bounds[0], Global.screen_bounds[1])
	pass

func _on_area_entered(area):
	$effects.play("flicker")
	health -= 1
	if health == 0:
		death(health)

func _on_sword_parry():
	$Sprite2D/AnimationPlayer.play("stun")
	await get_tree().create_timer(1.0).timeout
	if health != 0:
		$Sprite2D/AnimationPlayer.play("walk")
	pass
func death(health_counter):
	if health_counter == 0:
		enemydeath.emit()
		$sword.disconnect("parry", _on_sword_parry)
		set_process(false)
		$Sprite2D/AnimationPlayer.clear_queue()
		$playerdetection.monitoring = false
		speedvar = 0
		$Sprite2D/AnimationPlayer.play("death")
		await $Sprite2D/AnimationPlayer.animation_finished
		queue_free()
			

func attack(attacktype):
	speedvar = 0
	if attacktype == "upslash":
		$shine_effect/AnimationPlayer.play("downshine")
		$Sprite2D/AnimationPlayer.play("upslash")
		upattack.emit()
	elif attacktype == "downslash":
		$shine_effect/AnimationPlayer.play("upshine")
		$Sprite2D/AnimationPlayer.play("downslash")
		downattack.emit()
	elif attacktype == "sideslash":
		$shine_effect/AnimationPlayer.play("middleshine")
		$Sprite2D/AnimationPlayer.play("sideslash")
		sideattack.emit()
	$Sprite2D/AnimationPlayer.queue("RESET")


func _on_playerdetection_area_entered(area):
	if $playerdetection.has_overlapping_areas():
		attack(attackstring)
	pass # Replace with function body.


func _on_playerdetection_area_exited(area):
	$Sprite2D/AnimationPlayer.queue("walk")
	pass # Replace with function body.


func _on_downattack():
#	await $AnimationPlayer.current_animation_position == 0.3
#	$shine_effect/AnimationPlayer.play("upshine")
	pass # Replace with function body.


func _on_sideattack():
#	await $AnimationPlayer.current_animation_position == 0.3
	$shine_effect/AnimationPlayer.play("middleshine")
	pass # Replace with function body.


func _on_upattack():
#	await $AnimationPlayer.current_animation_position == 0.3
#	$shine_effect/AnimationPlayer.play("downshine")
	pass # Replace with function body.



