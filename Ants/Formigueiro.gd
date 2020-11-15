extends Area2D

#ants inside anthill ants_count eh o mudavel
export var ants_count = 25
export var max_ants = 50

#ant name#
var ant_id = 0
var antout = 0
var need_level_up = false
var strongest_ant = 1

#ants class
var workercount: int = 0
var warriorcount: int = 0

onready var collision = $CollisionShape2D
onready var timer = $Timer
onready var pathfinding = $"../Pathfinding"

onready var spawnermanager = $"../SpawnerManager"

onready var statchange = $"../CanvasLayer/StatChange"

onready var ExpBall = load("res://UI/ExpBall.tscn")

var formigas = []
var stats = []

var foodsource = 0 setget handle_foodsource

var anthillexp = 0
var anthilllevel = 1

export var balls_count = 1

onready var target_position = global_position

func initialize():
	GlobalSignals.connect("leveledup", self, "handle_exp")
	set_timer(2)
	var initial_position: Vector2 = spawnermanager.get_spawn_position()
	initial_position.x = clamp(initial_position.x, 100, 2400)
	initial_position.y = clamp(initial_position.y, 100, 1300)
	global_position = initial_position
	pass

func SpitAnt():
	ants_count -= 1
	antout += 1
	
	#instancia a formiga
	var InstancedAnt = preload ("res://Actors/Ants/Ant.tscn")
	var instancedAnt = InstancedAnt.instance()
	var world = get_tree().current_scene
	world.get_node("AntsManager").add_child(instancedAnt)
	
	#posicao formiga
	target_position = global_position
	target_position.y = target_position.y + rand_range(-10, 10)
	target_position.x = target_position.x + rand_range(-10,10)
	instancedAnt.global_position = target_position

	set_timer(rand_range(0,2))
	pass


func get_time_left():
	return timer.time_left
	pass

func set_timer(duration):
	timer.start(duration)
	pass

func handle_foodsource(new_value):
	foodsource = new_value
	if foodsource >= 300 and (ants_count + antout) < max_ants:
		foodsource = foodsource - 300
		ants_count = ants_count + 1
	return foodsource

func add_exp():
	print("se isso apararecer eh pq essa funcao nao eh inutil (linha 81 de formigueiro)~~~~")
	anthillexp = anthillexp + 1	
	pass

func handle_exp():
	anthillexp = clamp(anthillexp + 1, 0, anthilllevel * 20 )
	GlobalSignals.emit_signal("gained_exp")
	var expBall = ExpBall.instance()
	var world = get_tree().current_scene
	world.add_child(expBall)
	expBall.position = self.global_position
	if anthillexp == anthilllevel * 20:
		statchange.availablepoints += 1
		statchange.maxpoints += 1
		anthilllevel += 1
		anthillexp = 0
	pass

func _on_Formigueiro_body_entered(body):
	if body.is_in_group("obstacles"):
		body.remove_from_group("obstacles")
	if body.is_in_group("Ant") and body.state == 6:
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
		stats.append(body.stat.CLASS)
	
		#recurso pro formigueiro
		var foodchange = (body.stat.HUNGER -100)* -1
		foodsource = handle_foodsource(foodsource + foodchange)

		if body.stat.LEVEL > spawnermanager.spawner_level:
			spawnermanager.spawner_level = body.stat.LEVEL
		formigas.append(stats.duplicate(true))
		stats.clear()
		pass



func _on_Formigueiro_body_exited(body):
	body.add_to_group("obstacles", true)
	pass


func _on_Timer_timeout():
	if ants_count > 0: 
		SpitAnt()
	pass
