extends Area2D
@export var distance = 600
var direction = 1
@export var speed = 1000
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("rotate")
	scale.x = direction
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*direction*delta
	pass


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_area_entered(area):
	$Timer.stop()
	set_process(false)
	$AnimationPlayer.play("destroyed")
	await $AnimationPlayer.animation_finished
	queue_free()
	pass # Replace with function body.
