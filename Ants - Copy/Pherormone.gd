extends Area2D

var state = null
var posicao = null
onready var timer = $Timer
enum{
#	MOVE,
	ATTACK,
	CHASE,
	EAT,
	WANDER,
	SEARCH,
	IDLE
	VOLTAR
}


func _ready():
	timer.start(2)

func _on_Pherormone_body_entered(body):
	if posicao != null and body.stat.TYPE == "Ant":
		if body.state != VOLTAR: 
#		body.velocity = body.velocity.move_toward(direction_to * body.stat.MAX_SPEED, body.stat.ACCELERATION * delta)
#		body.rotation_degrees = posicao
#		print( body.stat.ANT_ID, " ",posicao)

#			body.state = state
#			body.obj_pos = posicao

			body.phero_obj_dir = posicao
			
		
			

		pass

func _on_Timer_timeout():
	queue_free()



