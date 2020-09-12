extends Area2D


export var ants_count = 0
var antnumber = 0

onready var collision = $CollisionShape2D
onready var timer = $Timer

var formigas = []
var stats = []


export var distancia = 5
onready var target_position = global_position

func _ready():
	set_timer(2)



func _process(delta):
	SpitAnt(formigas)
	
func _on_Formigueiro_body_entered(body):
	if body.state == 6:
		ants_count += 1
			
		stats.append(body.stat.ANT_NUMBER)
		stats.append(body.stat.MAX_HP)
		stats.append(body.stat.CUR_HP)
		stats.append(body.stat.ACCELERATION)
		stats.append(body.stat.MAX_SPEED)
		stats.append(body.stat.FRICTION)
		stats.append(body.stat.AWARENESS)
		stats.append(body.stat.DODGE)
		stats.append(body.stat.MAX_LEVEL)
		stats.append(body.stat.LEVEL)
		stats.append(body.stat.EXPERIENCE)
		stats.append(body.stat.HUNGER)
		stats.append(body.stat.THIRST)
	
		formigas.append(stats.duplicate(true))

		set_timer(2)
		stats.clear()


func SpitAnt(list):
	if get_time_left() <= .5 && ants_count > 0:
		ants_count -= 1
		
		#instancia a formiga
		var InstancedAnt = preload ("res://Ant.tscn")
		var instancedAnt = InstancedAnt.instance()
		var world = get_tree().current_scene
		world.add_child(instancedAnt)
		
		#posicao formiga
		target_position = global_position 
		instancedAnt.global_position = target_position
		
		#status da formiga instanciada
		if list.size() > 0: 
			list.shuffle()
			set_stats(instancedAnt, list)
			
		if instancedAnt.stat.ANT_NUMBER == 0:
			antnumber += 1
			instancedAnt.stat.ANT_NUMBER = antnumber
		(set_timer(rand_range(5,20)))
		
	


func get_time_left():
	return timer.time_left

func set_timer(duration):
	timer.start(duration)

func set_stats(ant, ants_list):
	
	var ant_stat = ants_list[0]
	ant.stat.ANT_NUMBER = ant_stat[0]
	ant.stat.MAX_HP = ant_stat[1]
	ant.stat.CUR_HP = ant_stat[2]
	ant.stat.ACCELERATION = ant_stat[3]
	ant.stat.MAX_SPEED = ant_stat[4]
	ant.stat.FRICTION = ant_stat[5]
	ant.stat.AWARENESS = ant_stat[6]
	ant.stat.DODGE = ant_stat[7]
	ant.stat.MAX_LEVEL = ant_stat[8]
	ant.stat.LEVEL = ant_stat[9]
	ant.stat.EXPERIENCE = ant_stat[10]
	ant.stat.HUNGER = 50
#	ant.stat.HUNGER = ant_stat[11]
	ant.stat.THIRST = ant_stat[12]
	

