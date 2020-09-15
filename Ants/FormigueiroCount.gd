extends Control


onready var label = $Label

func _process(delta):
		#INEFICIENTE, ARRUMAR EVENTUALMENTE
		var number = get_tree().current_scene.get_node("Formigueiro").ants_count
		label.text = "Ant Hill: " + str(number)
