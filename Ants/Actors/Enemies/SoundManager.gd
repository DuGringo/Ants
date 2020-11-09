extends Node


onready var camera = get_tree().current_scene.get_node("Camera2D")
onready var attack = $Attack
func _ready():
	$"../Stats".connect("loosing_health",self,"playdamaged")

func playattack():
	var distance2camera = camera.get_camera_screen_center().distance_to(get_parent().global_position)
	if distance2camera < 800:
		attack.play()
	
