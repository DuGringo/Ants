extends TextureButton

signal robot_pressed(pressionado)

var is_pressed = false
onready var camera = $"../../Camera2D"

onready var robot = $"../../AntsManager/Player" 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_RobotAntButton_pressed():
	if is_pressed == false:
		is_pressed = true
		emit_signal("robot_pressed",is_pressed)

	else:
		is_pressed = false
		emit_signal("robot_pressed",is_pressed)

