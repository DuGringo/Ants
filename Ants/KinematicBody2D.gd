
var velocity = Vector2.ZERO


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()


	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * stat.MAX_SPEED, stat.ACCELERATION * delta)
		animState.travel("Walk")
		look_at(velocity * 10000)
	else:
		animState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stat.FRICTION * delta)

	velocity = move_and_slide(velocity * delta)extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
