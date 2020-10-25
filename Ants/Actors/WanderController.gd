extends Node2D

export(int) var wander_range = 150

onready var start_position = global_position
onready var target_position = global_position
onready var target_vector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))

onready var timer = $Timer
onready var stat = $"../Stats"

func _ready():
	update_target_position()

func update_target_position():
	target_vector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	
	#testar
	if stat.CLASS == "Worker":
		update_start_position()
	if stat.CLASS == "Warrior":
		pass
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
