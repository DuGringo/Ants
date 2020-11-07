extends Node2D

onready var animPlayer = $AnimationPlayer
func _ready():
	var initial_position: Vector2 = Vector2.ZERO
	initial_position.x = rand_range(100, 2400)
	initial_position.y = rand_range( 100, 1300)
	global_position = initial_position
	animPlayer.play("blink")
