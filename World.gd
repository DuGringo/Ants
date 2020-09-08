extends Node2D



func _physics_process(delta):
	if Input.is_action_just_pressed("ui_click"):
		var FoodCube = load("res://Food.tscn")
		var foodCube = FoodCube.instance()
		var world = get_tree().current_scene
		world.add_child(foodCube)
		foodCube.global_position = get_global_mouse_position()
		
