extends RigidBody2D

onready var sound = $AudioStreamPlayer

func _on_Area2D_body_entered(body):
	sound.play()
