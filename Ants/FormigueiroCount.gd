extends Control


onready var anthill = $AnthillCount
onready var antsout = $AntsOut
onready var total = $Total
onready var workers = $Workers
onready var warriors = $Warriors

onready var formigueiro = get_tree().current_scene.get_node("Formigueiro")

func _process(_delta):
		#INEFICIENTE, ARRUMAR EVENTUALMENTE
		var dentro = formigueiro.ants_count
		anthill.text = "Ant Hill: " + str(dentro)
		
		var fora = formigueiro.antout
		antsout.text = "Outside: " + str(fora)
		
		var numtotal = dentro + fora
		total.text = "Total Ants: " + str(numtotal)
		
		var numworkers = formigueiro.workercount
		workers.text = "Workers: " + str(numworkers)
		
		var numwarriors = formigueiro.warriorcount
		warriors.text = "Warriors: " + str(numwarriors)
