extends Node2D
#
#var small_rect: Rect2 = Rect2(Vector2(0,0),Vector2(100,100))
#
#func _draw():
#	draw_rect()
export var time_between_cupcakes = 15
onready var timer = $Timer

var is_selection_on: bool = false
var stats_ant = null
var stats_actor_group
var same = null
var last_input = null

var spawner_level = 1

#for instancing
onready var world = get_tree().current_scene
#for instancing food
onready var FoodCube = load("res://Actors/Food/Food.tscn")

#for isntancing enemy
onready var Enemy = load("res://Actors/Enemies/Ladybug.tscn")
#for isntancing ants
onready var Ant = load("res://Actors/Ants/Ant.tscn")

#for instancing treasures
onready var Treasure = load("res://Objects/Treasure.tscn")

#for the stats modifier menu:
onready var modifierui = $"../CanvasLayer/StatChange"

#for spawnning in non-blocked areas
onready var pathfinding = $"../Pathfinding"
var tilemap: TileMap

func initialize():
	tilemap = pathfinding.tilemap
	timer.start(rand_range(1, 5))

func _input(_event):	
	if Input.is_action_just_pressed("StatsScreen"):
		if is_selection_on:
			modifierui.visible = false
			is_selection_on = false
		else:
			modifierui.visible = true
			is_selection_on = true

	if Input.is_key_pressed(70):
		last_input = "F"
	if Input.is_key_pressed(69):
		last_input = "E"
	if Input.is_key_pressed(65):
		last_input = "A"
	if Input.is_key_pressed(80):
		last_input = "P"
	
	#recarrega o mapa com barra de espaco
	if Input.is_action_just_pressed("ui_select"):
		get_tree().reload_current_scene()

	#funcoes do clique direito (instanciamento e delete da UI
	if Input.is_action_just_pressed("ui_click"):
		#Se existe um node StatsUI no nome, ele é deletado)
		if get_tree().current_scene.find_node("*StatsUI*", true , false):
			if stats_ant == null:
				KillUi()
			else:
				if stats_ant == same:
					KillUi()
					stats_ant = null
					same = null
				else:
					if stats_ant != same:
						KillUi()
						instance_ui()
		else:
			#se nao tem nenhum node criado, crie um.
			if stats_ant != null:
				instance_ui()

	#funcoes do clique esquerdo (instanciamento de comida, inimigo etc)
	if Input.is_action_just_pressed("ui_right_click"):
		#cria bolinhos depois de apertar F
		if last_input == "F":	
			var foodCube = FoodCube.instance()
			world.get_node("FoodsManager").add_child(foodCube)
			foodCube.stat.LEVEL = spawner_level
			foodCube.global_position = get_global_mouse_position()
			foodCube.global_position.y = foodCube.global_position.y -20
		#Cria Joaninha depois de apertar E
		if last_input == "E":
			var enemy = Enemy.instance()
			world.get_node("EnemiesManager").add_child(enemy)
			enemy.stat.LEVEL = spawner_level
			enemy.global_position = get_global_mouse_position()
		#Cria Formiga depois de apertar A
		if last_input == "A":
			var ant = Ant.instance()
			world.get_node("AntsManager").add_child(ant)
			ant.stat.LEVEL = spawner_level
			ant.global_position = get_global_mouse_position()
		#Cria super comida depois de paertar P
		if last_input == "P":
			var foodCube = FoodCube.instance()
			world.get_node("FoodsManager").add_child(foodCube)
			foodCube.global_position = get_global_mouse_position()
			foodCube.global_position.y = foodCube.global_position.y -20
			foodCube.stat.MAX_HP = 400 * (1 + spawner_level/10)
			foodCube.stat.CUR_HP = 400 * (1 + spawner_level/10)
			foodCube.valor_nutricional = 4 * (1 + spawner_level/10)
			foodCube.modulate = Color(1,1,0)

func KillUi():
	get_tree().current_scene.find_node("*StatsUI*",true,false).queue_free()
	get_tree().current_scene.find_node("*Setinha*",true,false).queue_free()

func instance_ui():
	var InstancedUi = preload ("res://UI/StatsUI.tscn")
	var instancedUi = InstancedUi.instance()
	var canvas = get_tree().current_scene.get_node("CanvasLayer")
	canvas.add_child(instancedUi)
	instancedUi.selected_ant = stats_ant

	var Setinha = preload ("res://UI/Setinha.tscn")
	var setinha = Setinha.instance()
	world.add_child(setinha)
	setinha.global_position = stats_ant.global_position
	setinha.selected_object = stats_ant
	setinha.object_group = stats_actor_group

	same = stats_ant
	stats_ant = null
	stats_actor_group = null


func get_spawn_position() -> Vector2:
	var posicao = Vector2(rand_range(20,2540), rand_range(20,1420))
	var posicao_coord = tilemap.world_to_map(posicao)
	var id = pathfinding.get_id_for_point(posicao_coord)
	if pathfinding.astar.is_point_disabled(id):
		return get_spawn_position()
	else:
		return posicao


func _on_Timer_timeout():
		if rand_range(0, 15) <= 1:
			var enemy = Enemy.instance()
			world.get_node("EnemiesManager").add_child(enemy)
			enemy.stat.LEVEL = spawner_level
			enemy.position = get_spawn_position()
			
		if rand_range(0,15) <= 1:
			var treasure = Treasure.instance()
			world.get_node("TreasureManager").add_child(treasure)
			treasure.position = get_spawn_position()

		var foodCube = FoodCube.instance()
		world.get_node("FoodsManager").add_child(foodCube)
		foodCube.position = get_spawn_position()
		timer.start(rand_range(5, time_between_cupcakes))


