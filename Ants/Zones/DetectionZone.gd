extends Area2D

var object = null


#func can_see_object():
#	return object != null
#func _physics_process(delta):
#	if self.overlaps_area(CollisionShape2D):
#		pass

func _on_DetectionZone_body_entered(body):
	object = body
	

func _on_DetectionZone_body_exited(body):
	object = null
