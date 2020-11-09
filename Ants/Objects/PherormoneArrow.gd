extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func rotate_towards(object: Vector2):
	var goal = global_position.direction_to(object).angle()
	if goal - rotation > PI:
		goal = goal - 2 * PI
	elif rotation - goal > PI:
		goal = 2 * PI + goal

	rotation = lerp(rotation, goal, 0.12)

	if rotation > 2*PI:
		rotation = rotation - 2*PI
	if rotation < 0:
		rotation = 2*PI + rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
