extends Area2D

var mesmo = null
var mouse_over = false
#func _input_event(viewport, event, shape_idx):
#	if event is InputEventMouseButton \
#	and event.button_index == BUTTON_LEFT \
#	and event.is_pressed():
#		get_tree().current_scene.stats_ant = self.get_parent()
		
		

#	else:
#		if get_tree().current_scene.get_node_or_null("StatsUI") == mesmo:
#			KillUi()
		
			
#func KillUi():
#	get_tree().current_scene.get_node_or_null("StatsUI").queue_free()
#	get_tree().current_scene.get_node_or_null("Setinha").queue_free()
#
#func instance_ui():
#	var InstancedUi = preload ("res://UI/StatsUI.tscn")
#	var instancedUi = InstancedUi.instance()
#	var world = get_tree().current_scene
#	world.add_child(instancedUi)
#	instancedUi.selected_ant = self.get_parent()
#
#
#	mesmo = get_tree().current_scene.get_node_or_null("StatsUI")
#	instancedUi.mesmo = mesmo
#
#
#	var Setinha = preload ("res://UI/Setinha.tscn")
#	var setinha = Setinha.instance()
#	world.add_child(setinha)
#	var target_position = self.global_position
#	target_position.y = target_position.y - 10
#	setinha.global_position = target_position
#	setinha.selected_ant = self.get_parent()

func _process(delta):
	if mouse_over:
		get_tree().current_scene.stats_ant = self.get_parent()
		get_tree().current_scene.stats_ant_type = self.get_parent().stat.TYPE


func _on_ClickArea_mouse_entered():
	mouse_over = true
	


func _on_ClickArea_mouse_exited():
	mouse_over = false
	get_tree().current_scene.stats_ant = null
