extends Area2D
var player
@onready var arm1 = $arm1/AnimationPlayer
@onready var arm2 = $arm2/AnimationPlayer
@onready var body = $body/AnimationPlayer
@export var idle_speed = 150
@export var dash_speed = 600
@export var final_phase = false
@export var first_phase = false
var health = 7
var arm1_parried = false
var arm2_parried = false
var attacks = ["up_slash", "down_slash"]
signal shoot_beam(item, position, direction)
signal died
signal hit
signal defeated
signal boss_appeared
var beam = preload("res://tscn_files/rotating_beam.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if body.current_animation == "dance":
		scale.x = (position.x - Global.player_position.x)/abs(position.x - Global.player_position.x)
		position.x += idle_speed*delta
		position.x = clamp(position.x, Global.screen_bounds[0], Global.screen_bounds[1] - 100)
	elif body.current_animation == "jump_up":
		position.y -= 1000*delta
	pass


func _on_visible_on_screen_notifier_2d_screen_entered():
	boss_appeared.emit()
	if first_phase:
		await get_tree().create_timer(1).timeout
		set_process(true)
		body.play("dance")
		attack()
	else:
		set_process(true)
		body.play("dance")
		attack()
	pass # Replace with function body.


func _on_attack_timer_timeout():
	attack()
	pass # Replace with function body.
func swing(arm, attackstring):
	arm.play(attackstring)
	if attackstring == "up_slash":
		$shine_effect/AnimationPlayer.play("downshine")
	else:
		$shine_effect/AnimationPlayer.play("upshine")
	pass
func attack():
	swing(arm1, attacks.pick_random())
	shoot_beam.emit(beam, Vector2(position.x - 50*scale.x, position.y), -scale.x)
	await arm1.animation_finished
	swing(arm2, attacks.pick_random())
	
	
func _on_animation_player_animation_started(anim_name):
	if anim_name == "dance":
		$attack_timer.start()
	pass # Replace with function body.

func jump_attack():
	pass

func _on_area_entered(area):
	hit.emit()
	$effects.play("flicker")
	health -= 1
	if health == 0:
		$attack_timer.stop()
		arm1.play("RESET")
		arm2.play("RESET")
		if final_phase:
			death()
		else:
			downed()
	pass # Replace with function body.

func death():
	set_process(false)
	$attack_timer.stop()
	body.play("death")
	died.emit()
	pass
func downed():
	$attack_timer.stop()
	body.play("down")
	body.queue("jump_up")
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	defeated.emit()
	pass # Replace with function body.


func _on_sword_parry():
	$attack_timer.stop()
	body.play("parry")
	await get_tree().create_timer(2).timeout
	if health > 0:
		body.play("dance")
		attack()
	pass






