extends "res://tscn_files/ninja.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	throw_shuriken.connect(get_node("/root/Node2D")._on_ninja_throw_shuriken)
	throw_bomb.connect(get_node("/root/Node2D")._on_ninja_throw_bomb)
	set_process(false)
	$Sprite2D.frame = 7
	pass # Replace with function body.

func _on_playerdetection_area_entered(area):
	if area == get_node("/root/Node2D/Player") or area == get_node("/root/Node2D/Player/shield"):
		scale.x = -scale.x
	pass

func _on_visible_on_screen_notifier_2d_screen_entered():
	
	pass
func _on_bomb_zone_area_entered(area):
	if area == get_node("/root/Node2D/Player") or area == get_node("/root/Node2D/Player/shield"):
		drop_bomb()
		$bomb_zone/CollisionShape2D.set_deferred("disabled", true)
		$Timer.start()
	pass # Replace with function body.


func _on_shuriken_zone_area_entered(area):
	if area == get_node("/root/Node2D/Player") or area == get_node("/root/Node2D/Player/shield"):
		shuriken_throw()
		$shuriken_zone/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.


func _on_timer_timeout():
	$shuriken_zone/CollisionShape2D.set_deferred("disabled", true)
	$bomb_zone/CollisionShape2D.set_deferred("disabled", true)
	$playerdetection/CollisionShape2D.set_deferred("disabled", true)
	set_process(true)
	speedvar = 200
	velocity = (Global.player_position.x - position.x)/abs(Global.player_position.x - position.x)
	jump(initial_velocity)
	$shuriken_zone.monitoring = false
	pass # Replace with function body.

func death():
	$Timer.stop()
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
