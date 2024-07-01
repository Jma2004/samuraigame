extends Area2D
var speed = 800
var direction
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D/AnimationPlayer.play("spin")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += speed * delta * direction
	pass


func _on_area_entered(area):
	set_process(false)
	$Sprite2D/AnimationPlayer.play("hit")
	await $Sprite2D/AnimationPlayer.animation_finished
	queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	pass # Replace with function body.
