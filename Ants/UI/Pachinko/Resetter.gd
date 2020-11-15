extends Area2D

onready var timer = $Timer
onready var deadball = null

onready var Ball = load("res://UI/Pachinko/Ball.tscn")



func _on_Resetter_body_entered(body):
	deadball = body
	timer.start(1.0)


func _on_Resetter_body_exited(body):
	deadball = null
	timer.stop()


func _on_Timer_timeout():
	if deadball != null:
		deadball.queue_free()
		var ball = Ball.instance()
		ball.position = Vector2(390,415)
		var board = get_parent().add_child(ball)
	

