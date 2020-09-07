extends KinematicBody2D

#const ACCELERATION = 800
#const MAX_SPEED = 100
#const FRICTION = 500

enum{
	MOVE,
	ATTACK,
	EAT,
	CHASE
}

var state = MOVE
var velocity = Vector2.ZERO


onready var anim : AnimationPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
onready var stat = $Stats

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

		ATTACK:
			attack_state(delta)

		EAT:
			eat_state(delta)
			
		CHASE:
			chase_state(delta)
	
	
func move_state(delta):
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
		
	move_and_collide(velocity * delta)
	
	if Input.is_action_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	animState.travel("Attack")
	velocity = Vector2.ZERO
	
func attack_animation_finished():
	state = MOVE

func eat_state(delta):
	pass

func chase_state(delta):
	pass
