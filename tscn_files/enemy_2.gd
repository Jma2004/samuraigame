extends "res://tscn_files/base_enemy.gd"
signal stunplayer
signal test_signal
@export var parry_health := 1
# Called when the node enters the scene tree for the first time.
func _ready():
	$sword.disable_attack = true
	attackstring = attacks[randi_range(0, 1)]
	speed *= speedscale
#	$shield.update_shield()
	$Sprite2D/AnimationPlayer.speed_scale = speedscale
	$Sprite2D/AnimationPlayer.play("walk")
	pass # Replace with function body.

func _on_sword_parry():
	parry_health -= 1
	if parry_health <= 0:
		$Sprite2D/AnimationPlayer.clear_queue()
		$Sprite2D/AnimationPlayer.play("stun")
		$shield.turn_off()
		await get_tree().create_timer(1.0).timeout
		if health > 0:
			$Sprite2D/AnimationPlayer.play("walk")
			$shield.update_shield()
	pass
	
func death(health_counter):
	if health_counter == 0:
		$sword.disconnect("parry", _on_sword_parry)
		set_process(false)
		$playerdetection.monitoring = false
		$Sprite2D/AnimationPlayer.clear_queue()
		enemydeath.emit()
		speedvar = 0
		$Sprite2D/AnimationPlayer.play("death")
		await $Sprite2D/AnimationPlayer.animation_finished
		queue_free()
	pass
			

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
	$Sprite2D/AnimationPlayer.queue("walk")
	pass
	
#func parry(attacktype):
#	speedvar = 0
#	if attacktype == "upslash":
#		$shine_effect/AnimationPlayer.play("downshine")
#		$Sprite2D/AnimationPlayer.play("upslash_parry")
#		upattack.emit()
#	elif attacktype == "downslash":
#		$shine_effect/AnimationPlayer.play("upshine")
#		$Sprite2D/AnimationPlayer.play("downslash_parry")
#		downattack.emit()
#	elif attacktype == "sideslash":
#		$shine_effect/AnimationPlayer.play("middleshine")
#		$Sprite2D/AnimationPlayer.play("sideslash_parry")
#		sideattack.emit()
#	await $Sprite2D/AnimationPlayer.animation_finished
#	attack(attackstring)
#	pass
	

func _on_shield_area_entered(area):
	stunplayer.emit()
	pass # Replace with function body.


func _on_shield_shield_broken():
#	monitoring = true
	pass # Replace with function body.
