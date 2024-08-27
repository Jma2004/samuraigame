extends Area2D
@export var health = 3
signal enemydeath
# Called when the node enters the scene tree for the first time.
func _ready():
	scale.x = (position.x - Global.player_position.x)/abs(Global.player_position.x - position.x)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_entered():
	$Timer.start()
	pass # Replace with function body.


func _on_timer_timeout():
	$Sprite2D/AnimationPlayer.play("whip")
	await $Sprite2D/AnimationPlayer.animation_finished
	$whip/Sprite2D/AnimationPlayer.play("attack")
	$whip/Sprite2D/AnimationPlayer.queue("recoil")
	await $whip/Sprite2D/AnimationPlayer.animation_finished
	$Timer.start()
	$Sprite2D/AnimationPlayer.play("RESET")
	pass # Replace with function body.


func _on_area_entered(area):
	health -= 1
	$effects.play("flicker")
	if health == 0:
		enemydeath.emit()
		$Timer.stop()
		$CollisionShape2D.set_deferred("disabled", true)
		$Sprite2D/AnimationPlayer.play("death")
		await $Sprite2D/AnimationPlayer.animation_finished
		queue_free()
	pass # Replace with function body.
