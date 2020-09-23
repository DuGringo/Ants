extends Area2D

var state = null
var direction_to = null
onready var timer = $Timer



func _ready():
	timer.start(3)

func _on_Pherormone_body_entered(body):
	if direction_to != null:
		body.look_at(direction_to * 10000)


func _on_Timer_timeout():
	queue_free()
