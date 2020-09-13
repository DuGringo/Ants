extends Node2D
#
#var small_rect: Rect2 = Rect2(Vector2(0,0),Vector2(100,100))
#
#func _draw():
#	draw_rect()
export var max_time = 15
onready var timer = $Timer

var stats_ant = null
var same = null



func _ready():
	timer.start(rand_range(1, 5))
	
	#instancia o formigueiro:
	var Formigueiro = load("res://Formigueiro.tscn")
	var formigueiro = Formigueiro.instance()
	var world = get_tree().current_scene
	world.add_child(formigueiro)
	formigueiro.position = Vector2(rand_range(50,590), rand_range(10,290))
	
	
#func set_same(mesmo):
#	same = mesmo
#	print(same)
	
func _physics_process(delta):
	
	#cria bolinhos com right click
	if Input.is_action_just_pressed("ui_right_click"):
		var FoodCube = load("res://Food.tscn")
		var foodCube = FoodCube.instance()
		var world = get_tree().current_scene
		world.add_child(foodCube)
		foodCube.global_position = get_global_mouse_position()
		foodCube.global_position.y = foodCube.global_position.y -20
	#cria bolinhos em um timer
	if timer.time_left <= .5:
		var FoodCube = load("res://Food.tscn")
		var foodCube = FoodCube.instance()
		var world = get_tree().current_scene
		world.add_child(foodCube)
		foodCube.position = Vector2(rand_range(20,620), rand_range(20,310))
		timer.start(rand_range(1, max_time))


func _input(event):
	#recarrega o mapa com barra de espaco
	if Input.is_action_just_pressed("ui_select"):
		get_tree().reload_current_scene()
	#funcoes do clique direito (instanciamento e delete da UI
	if Input.is_action_just_pressed("ui_click"):
		
		same = stats_ant
		print(same)
		#se existe um node, ele eh deletado.
		if get_node_or_null("StatsUI") != null:
			if stats_ant == null:
				KillUi()
			else:
				if stats_ant == same:
					KillUi()
					stats_ant = null
				else:
					if stats_ant != same:
						KillUi()
						instance_ui()
		else:
			#se nao tem nenhum node criado, crie um.
			if stats_ant != null:
				instance_ui()


func KillUi():
	get_node("StatsUI").queue_free()
	get_node("Setinha").queue_free()

func instance_ui():
	var InstancedUi = preload ("res://UI/StatsUI.tscn")
	var instancedUi = InstancedUi.instance()
	var world = get_tree().current_scene
	world.add_child(instancedUi)
	instancedUi.selected_ant = stats_ant
	
	#same eh melhor aqui
#	same = stats_ant
	

	var Setinha = preload ("res://UI/Setinha.tscn")
	var setinha = Setinha.instance()
	world.add_child(setinha)
	var target_position = stats_ant.global_position
	target_position.y = target_position.y - 10
	setinha.global_position = target_position
	setinha.selected_ant = stats_ant

	stats_ant = null

