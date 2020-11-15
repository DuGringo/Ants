extends Control


onready var anthill = $VBoxContainer/HBoxContainer/AnthillCount
onready var anthillcapacity = $VBoxContainer/HBoxContainer/Capacity
onready var antsout = $VBoxContainer/AntsOut
onready var total = $VBoxContainer/Total
onready var workers = $VBoxContainer/Workers
onready var warriors = $VBoxContainer/Warriors
onready var ballscountlabel = $BallsCountLabel

onready var formigueiro = get_tree().current_scene.get_node("Formigueiro")

func _process(_delta):
		#INEFICIENTE, ARRUMAR EVENTUALMENTE~~~~
		var dentro = formigueiro.ants_count
		anthill.text = "Ant Hill: " + str(dentro)
		
		var capacity = formigueiro.max_ants
		anthillcapacity.text = "/" + str(capacity)
		
		var fora = formigueiro.antout
		antsout.text = "Outside: " + str(fora)
		
		var numtotal = dentro + fora
		total.text = "Total Ants: " + str(numtotal)
		
		var numworkers = formigueiro.workercount
		workers.text = "Workers: " + str(numworkers)
		
		var numwarriors = formigueiro.warriorcount
		warriors.text = "Warriors: " + str(numwarriors)

		var ballsnumber = formigueiro.balls_count
		ballscountlabel.text = "x" + str(ballsnumber)
