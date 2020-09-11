extends Area2D


export var ants_count = 0
var antnumber = 0

onready var collision = $CollisionShape2D
onready var timer = $Timer

var formigas = []
var stats = []



var resetado = false

export var distancia = 5
onready var target_position = global_position

func _ready():
	set_timer(2)

func _process(delta):
	SpitAnt(formigas)
	
func _on_Formigueiro_body_entered(body):
	if body.state == 6:
		ants_count += 1
		antnumber += 1
		print(ants_count)
		stats.append(antnumber)
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
	
		formigas.append(stats)
		set_timer(2)
		stats.clear()
	

func SpitAnt(list):
	if get_time_left() <= .5 && resetado == true && ants_count > 0:
		resetado = false
		ants_count -= 1
		print(ants_count)
		
		
		#instancia a formiga
		var InstanceAnt = preload ("res://Ant.tscn")
		var instanceAnt = InstanceAnt.instance()
		var world = get_tree().current_scene
		world.add_child(instanceAnt)
		
		#posicao formiga
		#var target_vector = Vector2(rand_range(-distancia,distancia), rand_range(-distancia,distancia))
		target_position = global_position 
		instanceAnt.global_position = target_position
		
		#conectando sinal, nao funciona.
		#instanceAnt.connect("entrou_formigueiro", self, "morri")
		
		#aqui eventualmente vai dar os status da lista pra formiga instanciada
		#if list[0]!= null:
		#	list.shuffle()
		#	var antStats = list.pop_back()
			#set_stats(instanceAnt, antStats)
			#detalhe: pop_back NAO RETORNA O VALOR(?), encontrar funcao melhor
		
		set_timer(5)
	elif get_time_left() <= .5 && resetado == false:
		resetado = true
		set_timer(rand_range(1,15))

func get_time_left():
	return timer.time_left

func set_timer(duration):
	timer.start(duration)

func set_stats(variavel, lista):
	variavel.stat.MAX_HP = lista[1]
	variavel.stat.CUR_HP = lista[2]
	variavel.stat.ACCELERATION = lista[3]
	variavel.stat.MAX_SPEED = lista[4]
	variavel.stat.FRICTION = lista[5]
	variavel.stat.AWARENESS = lista[6]
	variavel.stat.DODGE = lista[7]
	variavel.stat.MAX_LEVEL = lista[8]
	variavel.stat.LEVEL = lista[9]
	variavel.stat.EXPERIENCE = lista[10]
	variavel.stat.HUNGER = lista[11]
	variavel.stat.THIRST = lista[12]

