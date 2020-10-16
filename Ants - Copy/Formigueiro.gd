extends Area2D

#ants inside anthill ants_count eh o mudavel, Anthill_count é o update...
export var ants_count = 0
#onready var anthill_count = ants_count
#ant name#
var ant_id = 0
var antout = 0
var need_level_up = false
var strongest_ant = 1

onready var collision = $CollisionShape2D
onready var timer = $Timer
onready var pathfinding = $"../Pathfinding"


var formigas = []
var stats = []

var foodsource = 0

onready var target_position = global_position

func _ready():
	set_timer(2)
	var initial_position: Vector2 =  Vector2(abs(rand_range(100, 2400)),abs(rand_range(100, 1300)))
#	global_position = pathfinding.astar.get_point_position(pathfinding.astar.get_closest_point(initial_position))
	

#	pathfinding.astar.get_point_position
func _process(delta):
	
	if ants_count > 0: 
		SpitAnt()
#	anthill_count = ants_count
	
	
func _on_Formigueiro_body_entered(body):
	if body.state == 6:
		ants_count += 1
		if body.stat.EXPERIENCE >= body.stat.LEVEL:
			need_level_up = true
		else:
			need_level_up = false
			
		stats.append(body.stat.ANT_ID)
		stats.append(body.stat.MAX_HP)
		stats.append(body.stat.CUR_HP)
		stats.append(body.stat.ACCELERATION)
		stats.append(body.stat.MAX_SPEED)
		stats.append(body.stat.FRICTION)
		stats.append(body.stat.AWARENESS)
		stats.append(body.stat.DAMAGE)
		stats.append(body.stat.DODGE)
		stats.append(body.stat.MAX_LEVEL)
		stats.append(body.stat.LEVEL)
		stats.append(body.stat.EXPERIENCE)
		stats.append(body.stat.HUNGER)
		stats.append(body.stat.THIRST)
		stats.append(need_level_up)
	
		#resurso pro formigueiro
		foodsource = foodsource + (body.stat.HUNGER - 100)*-1
		if foodsource >= 300:
			foodsource = foodsource - 300
			ants_count = ants_count + 1
		if body.stat.LEVEL > strongest_ant:
			strongest_ant = body.stat.LEVEL
		
		
		formigas.append(stats.duplicate(true))
		stats.clear()


func SpitAnt():
	if get_time_left() <= .5 && ants_count > 0:
		ants_count -= 1
		antout += 1
		
		#instancia a formiga
		var InstancedAnt = preload ("res://Ant.tscn")
		var instancedAnt = InstancedAnt.instance()
		var world = get_tree().current_scene
		world.add_child(instancedAnt)
		
		#posicao formiga
		target_position = global_position
		target_position.y = target_position.y + 20 + rand_range(-2, 2)
		target_position.x = target_position.x + rand_range(-2,2)
		instancedAnt.global_position = target_position

		set_timer(rand_range(0.2,2))
		
	


func get_time_left():
	return timer.time_left

func set_timer(duration):
	timer.start(duration)
	


	
