extends Node
var player_health := 3
var player_shield := 0
var player_points := 0
var player_lives := 3
var player_speed := 0
signal player_died
var screensize
var level := 1
var screen_bounds := [0.0, 1142.0]
var player_position := Vector2()
var ground
# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset_variables():
	player_health = 3
	player_lives = 3
	player_shield = 0
	player_points = 0	
	player_speed = 0
	level = 1
	screen_bounds = [0.0, 1142.0]
