extends Node2D
#
#var small_rect: Rect2 = Rect2(Vector2(0,0),Vector2(100,100))
#
#func _draw():
#	draw_rect()
export var max_time = 15
onready var timer = $Timer

func _ready():
	timer.start(rand_range(1, 5))
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_click"):
		var FoodCube = load("res://Food.tscn")
		var foodCube = FoodCube.instance()
		var world = get_tree().current_scene
		world.add_child(foodCube)
		foodCube.global_position = get_global_mouse_position()
		
		
	if timer.time_left <= .5:
		var FoodCube = load("res://Food.tscn")
		var foodCube = FoodCube.instance()
		var world = get_tree().current_scene
		world.add_child(foodCube)
		foodCube.position = Vector2(rand_range(0,640), rand_range(0,360))
		timer.start(rand_range(1, max_time))
