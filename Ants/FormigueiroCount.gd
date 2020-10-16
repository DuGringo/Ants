extends Control


onready var anthill = $AnthillCount
onready var antsout = $AntsOut

func _process(_delta):
		#INEFICIENTE, ARRUMAR EVENTUALMENTE
		var dentro = get_tree().current_scene.get_node("Formigueiro").ants_count
		anthill.text = "Ant Hill: " + str(dentro)
		var fora = get_tree().current_scene.get_node("Formigueiro").antout
		antsout.text = "Outside: " + str(fora)
