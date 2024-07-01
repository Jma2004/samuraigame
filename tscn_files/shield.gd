extends Area2D
@export var shield_health := 1
signal shield_broken
# Called when the node enters the scene tree for the first time.
func _ready():
	if shield_health == 0:
		turn_off()
	else:
		turn_on()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_shield():
	if shield_health > 0:
		turn_on()
	if shield_health == 0:
		$CollisionShape2D.set_deferred("disabled", true)
		shield_broken.emit()
		$AnimationPlayer.play("shield_break")
		await $AnimationPlayer.animation_finished
		$Sprite2D.frame = 0
		hide()
		get_parent().set_deferred("monitorable", true)
		get_parent().set_deferred("monitoring", true)
	pass


func _on_area_entered(area):
	$AudioStreamPlayer.play()
	shield_health -= 1
	update_shield()
	pass # Replace with function body.

func turn_off():
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	get_parent().set_deferred("monitorable", true)
	get_parent().set_deferred("monitoring", true)
	pass

func turn_on():
	show()
	$ColorRect.color.a8 = 80 + 5*shield_health
	$CollisionShape2D.set_deferred("disabled", false)
	get_parent().set_deferred("monitorable", false)
	get_parent().set_deferred("monitoring", false)
