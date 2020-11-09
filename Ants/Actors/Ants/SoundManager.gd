extends Node

#onready var camera = $"../../../Camera2D"
onready var camera = get_tree().current_scene.get_node("Camera2D")
onready var damaged = $Damaged
func _ready():
	$"../Stats".connect("loosing_health",self,"playdamaged")

func playdamaged():
	var distance2camera = camera.get_camera_screen_center().distance_to(get_parent().global_position)
	if distance2camera < 800:
		damaged.play()
	
