extends AudioStreamPlayer
var intro = preload("res://game_music/brejeiro.mp3")
var level_1 = preload("res://game_music/bacarra.mp3")
var level_2 = preload("res://game_music/Odeon.mp3")
var level_3 = preload("res://game_music/concolacao_live.mp3")
var level_4 = preload("res://game_music/Recuerdos de la Alhambra.mp3")
var music = [intro, level_1, level_2, level_3, level_4]
# Called when the node enters the scene tree for the first time.
func _ready():
	stream = intro
	play()
	pass # Replace with function body.




