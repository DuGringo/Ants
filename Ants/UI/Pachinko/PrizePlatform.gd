extends StaticBody2D

enum{
	A,
	B,
	C,
	D,
	E
	
}

export var variety = A

onready var board = get_parent().get_parent()
onready var timer = $Timer
onready var deadball = null
onready var formigueiro = get_tree().current_scene.get_node("Formigueiro")
onready var Ball = load("res://UI/Pachinko/Ball.tscn")
onready var statchange = get_tree().current_scene.get_node("CanvasLayer/StatChange")

func _on_Timer_timeout():
	if deadball != null:
		deadball.queue_free()
		formigueiro.balls_count -= 1
		match variety:
			A:
#				board.score[0] += 1
#				+2 balls
				formigueiro.balls_count = formigueiro.balls_count + 2
			B:
#				board.score[1] += 1
#				+1 skill point
				statchange.availablepoints += 1
				statchange.maxpoints += 1
			C:
#				board.score[2] += 1
#				+10 ants in anthill
				formigueiro.ants_count = formigueiro.ants_count + 10
			D:
#				board.score[3] += 1
				formigueiro.max_ants = formigueiro.max_ants + 5
#				+5 max ants
			E:
#				board.score[4] += 1
#				+2 skill points
				statchange.availablepoints += 2
				statchange.maxpoints += 2

		if formigueiro.balls_count > 0:
			var ball = Ball.instance()
			ball.position = Vector2(390,415)
			var board = get_parent().add_child(ball)
#		print(board.score)

func _on_detecta_body_entered(body):
	deadball = body
	timer.start(1.0)


func _on_detecta_body_exited(body):
	deadball = null
	timer.stop()
