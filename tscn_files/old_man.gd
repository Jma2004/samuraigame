extends Area2D
@export var shield = 0
signal stun_player
@export var shuriken_state = false
var shuriken = preload("res://tscn_files/shuriken.tscn")
signal throw_shuriken(item, direction, location)
# Called when the node enters the scene tree for the first time.
func _ready():
	if shield != 0:
		$shield.shield_health = shield
		$shield.update_shield()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_sword_parry():
	$Timer.stop()
	$Sprite2D/AnimationPlayer.play("stun")
	$shield.turn_off()
	await get_tree().create_timer(1.0).timeout
	$Timer.start()
	$shield.update_shield()
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

	


func _on_shield_area_entered(area):
	stun_player.emit()
	pass # Replace with function body.
