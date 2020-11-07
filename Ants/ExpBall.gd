extends Node2D

onready var animPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("Die")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func die():
	queue_free()
