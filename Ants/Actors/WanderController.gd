extends Node2D

var wander_range = 150

onready var start_position = global_position
onready var target_position = global_position
onready var target_vector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))

onready var timer = $Timer
onready var stat = $"../Stats"
onready var formigueiro = get_tree().current_scene.get_node("Formigueiro")


func _ready():
	update_target_position()
	if stat.CLASS == "Warrior":
		wander_range = 500

func update_target_position():
	target_vector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	
	#testar
	if stat.CLASS == "Worker":
		update_start_position()
	if stat.CLASS == "Warrior":
		start_position = formigueiro.global_position
	#target_position = target_position + target_vector
	target_position = start_position + target_vector
	
	
	
func update_start_position():
	start_position = global_position

func get_time_left():
	return timer.time_left

func set_wander_timer(duration):
	timer.start(duration)
	
func _on_Timer_timeout():
	update_target_position()
