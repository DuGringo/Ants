extends Area2D

#ants inside anthill ants_count eh o mudavel, Anthill_count é o update...
export var ants_count = 0
onready var anthill_count = ants_count
#ant name#
var antnumber = 0
var need_level_up = false

onready var collision = $CollisionShape2D
onready var timer = $Timer

var formigas = []
var stats = []

onready var target_position = global_position

func _ready():
	set_timer(2)
	get_tree().current_scene.get_node("Camera2D").posicao = global_position



func _process(delta):
	SpitAnt()
	anthill_count = ants_count
func _on_Formigueiro_body_entered(body):
	if body.state == 6:
		ants_count += 1
		if body.stat.EXPERIENCE >= body.stat.LEVEL * 5:
			need_level_up = true
		else:
			need_level_up = false
			
		stats.append(body.stat.ANT_NUMBER)
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
	
		formigas.append(stats.duplicate(true))
		stats.clear()


func SpitAnt():
	if get_time_left() <= .5 && ants_count > 0:
		ants_count -= 1
		
		#instancia a formiga
		var InstancedAnt = preload ("res://Ant.tscn")
		var instancedAnt = InstancedAnt.instance()
		var world = get_tree().current_scene
		world.add_child(instancedAnt)
		
		#posicao formiga
		target_position = global_position
		target_position.y = target_position.y + 20 
		instancedAnt.global_position = target_position

		set_timer(rand_range(3,10))
		
	


func get_time_left():
	return timer.time_left

func set_timer(duration):
	timer.start(duration)
