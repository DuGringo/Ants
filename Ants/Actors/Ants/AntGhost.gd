extends Node2D

onready var animPlayer = $AnimationPlayer
onready var sound = $AudioStreamPlayer
onready var camera = get_tree().current_scene.get_node("Camera2D")

func _ready():
	animPlayer.play("dying")
	var distance2camera = camera.get_camera_screen_center( ).distance_to(global_position)
	if distance2camera < 800:
		sound.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func die():
	queue_free()
 
