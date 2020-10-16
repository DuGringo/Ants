extends Node2D

var selected_object = null
var object_group = null

func _process(_delta):
	
	if selected_object != null:
		global_position = selected_object.global_position
		var target_position = self.global_position
		target_position.y = target_position.y - 10
		if object_group == "Enemy" :
			target_position.y = target_position.y - 25
		global_position = target_position
	else:
		queue_free()
