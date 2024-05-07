extends Area2D
@export var disable_attack = true
signal parry
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if disable_attack:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
		$Swordswing.play()



func _on_area_entered(area):
	$AnimationPlayer.play("parryeffect")
	parry.emit()
