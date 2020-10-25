extends Area2D

var mesmo = null
var mouse_over = false

func _process(_delta):
	if mouse_over:
		get_tree().current_scene.get_node("SpawnerManager").stats_ant = self.get_parent()
		get_tree().current_scene.get_node("SpawnerManager").stats_actor_group = str(self.get_parent().get_groups()[0])


func _on_ClickArea_mouse_entered():
	mouse_over = true
	


func _on_ClickArea_mouse_exited():
	mouse_over = false
	get_tree().current_scene.get_node("SpawnerManager").stats_ant = null
