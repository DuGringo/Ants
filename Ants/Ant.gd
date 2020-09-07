extends KinematicBody2D

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
#Finding
onready var detectionZone = $DetectionZone
#Attack
onready var detectionZone2 = $DetectionZone2

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			seek_zone()

		ATTACK:
			attack_state(delta)

		EAT:
			eat_state(delta)
			
		CHASE:
			var object = detectionZone.object
			if object != null:
				var direction = (object.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction* stat.MAX_SPEED, stat.ACCELERATION * delta)
				animState.travel("Walk")
				look_at(velocity * 10000)
				should_attack()
				
			
			
				
	velocity = move_and_slide(velocity)
	
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
	


func eat_state(delta):
	
	var food = detectionZone2.object
	
	if food != null:
		animState.travel("Attack")
		velocity = Vector2.ZERO
		
		
		
	
		
		

func chase_state(delta):
	pass
	
func attack_animation_finished():
	state = MOVE
	
func seek_zone():
	if detectionZone.can_see_object():
		state = CHASE
func should_attack():
	if detectionZone2.can_see_object():
		state = EAT
