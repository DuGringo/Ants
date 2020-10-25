extends Area2D

#VV isso server pra algo??? retirar!! VV
var id = "Pherormone"

var objid = null

var objtype = null

var state = null
var posicao = null
onready var timer = $Timer
onready var collisionshape = $CollisionShape2D
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
	if posicao != null and body.is_in_group("Ant"):
		if body.state != VOLTAR: 
			body.phero_obj_dir = posicao
			body.pheroid = objid
			body.phero_obj_type = objtype
		
			

		pass

func _on_Timer_timeout():
	collisionshape.disabled = true



