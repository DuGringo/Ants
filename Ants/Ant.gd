extends KinematicBody2D

enum{
	MOVE,
	ATTACK,
	EAT,
	CHASE,
	WANDER,
	SEARCH,
	IDLE
}

var state = WANDER
var velocity = Vector2.ZERO
export(int) var WANDER_TARGET_RANGE = 2

var is_searching = false
var is_idle = false

var state_list = [WANDER, WANDER, WANDER, WANDER, IDLE, IDLE, IDLE, SEARCH]

onready var anim : AnimationPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
onready var stat = $Stats
#Finding
onready var detectionZone = $DetectionZone
#Attack
onready var detectionZone2 = $DetectionZone2
onready var wanderController = $WanderController



func _physics_process(delta):
	match state:
		MOVE:
			seek_zone()
			move_state(delta)
			

		ATTACK:
			attack_state(delta)

		EAT:
			eat_state(delta)

		CHASE:
			chase_state(delta)

		WANDER:
			seek_zone()
			wander_state(delta)
			
			

		SEARCH:
			seek_zone()
			search_state(delta)
		
		IDLE:
			seek_zone()
			idle_state(delta)
			
	


	velocity = move_and_slide(velocity)
	
#state 0
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
#state 1
func attack_state(delta):
	animState.travel("Attack")
	velocity = Vector2.ZERO
#state 2
func eat_state(delta):
	
	var food = detectionZone2.object
	
	if food != null:
		animState.travel("Attack")
		velocity = Vector2.ZERO
	else:
		state = IDLE
#state 3
func chase_state(delta):
	var object = detectionZone.object
	if object != null:
		#var direction = (object.global_position - global_position).normalized()
		var direction = global_position.direction_to(object.global_position)
		velocity = velocity.move_toward(direction* stat.MAX_SPEED, stat.ACCELERATION * delta)
		animState.travel("Walk")
		look_at(velocity * 10000)
		should_attack()
	else:
		state = IDLE
#state 4
func wander_state(delta):
	if is_searching != true:
		if wanderController.get_time_left() == 0:
			state = pick_random_state(state_list)
			wanderController.set_wander_timer(rand_range(1,2))
		var direction = global_position.direction_to(wanderController.target_position)
		velocity = velocity.move_toward(direction* stat.MAX_SPEED, stat.ACCELERATION * delta)
		look_at(velocity * 10000)
		if direction != Vector2.ZERO:
			animState.travel("Walk")
	
	if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				velocity = Vector2.ZERO
				animState.travel("Idle")
				state = pick_random_state(state_list)
#state 5
func search_state(delta):
	is_searching = true
	animState.travel("Search")
	velocity = Vector2.ZERO
#state 6 
func idle_state(delta):
	if is_idle == false:
		is_idle = true
		wanderController.set_wander_timer(rand_range(1,3))
		animState.travel("Idle")
		velocity = Vector2.ZERO

	if  wanderController.get_time_left() == 0:
		state = pick_random_state(state_list)
		is_idle = false


func attack_animation_finished():
	state = WANDER

func seek_zone():
	if detectionZone.can_see_object():
		state = CHASE
	#else:
	#	state = WANDER

func should_attack():
	if detectionZone2.can_see_object():
		state = EAT

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list[1]
	#return state_list.pop_out()

func search_animation_finished():
	state = WANDER
	is_searching = false
