extends Node2D

onready var animPlayer = $AnimationPlayer
var premios : Array = ["+1 Skill Point", "+2 Skill Point","+1 Max Ants", "+2 Max Ants", "+5 Max Ants", "+1 Ants",  "+5 Ants", "+10 Ants"]

func _ready():
	randomize()
	premios.shuffle()
	var initial_position: Vector2 = Vector2.ZERO
	initial_position.x = rand_range(100, 2400)
	initial_position.y = rand_range( 100, 1300)
	global_position = initial_position
	animPlayer.play("blink")
