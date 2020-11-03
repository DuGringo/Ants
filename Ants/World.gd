extends Node2D

onready var formigueiro = $Formigueiro
onready var spawnermanager = $SpawnerManager
onready var pathfinding = $Pathfinding
onready var ground = $Ground
onready var player = $"AntsManager/Player"

func _ready():
	randomize()
	pathfinding.initialize(ground)
	spawnermanager.initialize()
	formigueiro.initialize()
	player.initialize()
