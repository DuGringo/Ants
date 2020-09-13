extends Node2D

var selected_ant = null

func _process(delta):
	
	if selected_ant != null:
		global_position = selected_ant.global_position
		var target_position = self.global_position
		target_position.y = target_position.y - 10
		global_position = target_position
	else:
		queue_free()
