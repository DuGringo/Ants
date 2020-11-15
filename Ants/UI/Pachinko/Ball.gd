extends RigidBody2D

func _ready():
	randomize()
	var bounciness = float((rand_range(5,10))/10)
	bounce = bounciness

