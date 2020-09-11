extends KinematicBody2D

enum{
#	MOVE,
	ATTACK,
	CHASE,
	EAT,
	WANDER,
	SEARCH,
	IDLE
	VOLTAR
}


var state = WANDER
var velocity = Vector2.ZERO
export(int) var WANDER_TARGET_RANGE = 2

var is_searching = false
var is_idle = false

var just_born = true

var state_list = [WANDER, WANDER, WANDER, WANDER, IDLE, IDLE, IDLE, SEARCH, SEARCH, SEARCH, SEARCH]

onready var anim : AnimationPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
#onready var formigueiro = $Formigueiro
onready var formigueiro = get_node("../Formigueiro")

onready var hitbox = get_node("Hitbox/CollisionShape2D")


onready var stat = $Stats
#Finding
onready var detectionZone = $DetectionZone
#Attack
onready var detectionZone2 = $DetectionZone2

onready var wanderController = $WanderController


func _ready():
	
	#connect("entrou_formigueiro", self, "morri")
	animTree.active = true
	
func _physics_process(delta):
	
	match state:
#		MOVE:
#			seek_zone()
#			move_state(delta)
			
#state 0
		ATTACK:
			attack_state(delta)
#stat1 
		CHASE:
			chase_state(delta)
			find_food(delta)
#state 2
		EAT:
			eat_state(delta)
#state 3
		WANDER:
			seek_zone()
			wander_state(delta)
			find_food(delta)
#state 4
		SEARCH:
			seek_zone()
			search_state(delta)
			find_food(delta)
#state 5
		IDLE:
			seek_zone()
			idle_state(delta)
			find_food(delta)
#state 6
		VOLTAR:
			voltar_state(delta)


	velocity = move_and_slide(velocity)
	
#state 0
#func move_state(delta):
#	var input_vector = Vector2.ZERO
#	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#	input_vector = input_vector.normalized()
#
#
#	if input_vector != Vector2.ZERO:
#		velocity = velocity.move_toward(input_vector * stat.MAX_SPEED, stat.ACCELERATION * delta)
#		animState.travel("Walk")
#		look_at(velocity * 10000)
#	else:
#		animState.travel("Idle")
#		velocity = velocity.move_toward(Vector2.ZERO, stat.FRICTION * delta)
#
#	move_and_collide(velocity * delta)
#
#
#	if Input.is_action_pressed("attack"):
#		state = ATTACK 

#state 0
func attack_state(delta):
	animState.travel("Attack")
	velocity = Vector2.ZERO
#state 1
func eat_state(delta):
	animState.travel("Attack")
	velocity = Vector2.ZERO
	
	var food = detectionZone2.object
	if food != null:
		if food.mordida == true:
			stat.HUNGER = stat.HUNGER - food.valor_nutricional
	if stat.HUNGER <= 1 :
		state = VOLTAR
	
#state 2
func chase_state(delta):
	
	var object = detectionZone.object
	var object_position = null
	if object != null:
		detectionZone.rotation = 0
		#var direction = (object.global_position - global_position).normalized()
		look_and_move(object.global_position , delta)
		should_attack()
		object_position = object.global_position
	else:
		#state = pick_random_state(state_list)
		state = IDLE
	#if object_position != null and global_position.distance_to(object_position) <= 5:
		
		
	
#state 3
func wander_state(delta):
	if is_searching != true:
		if wanderController.get_time_left() == 0:
			state = pick_random_state(state_list)
			wanderController.set_wander_timer(rand_range(1,2))
		look_and_move(wanderController.target_position , delta)
		
		
		
	
	if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				velocity = Vector2.ZERO
				animState.travel("Idle")
				state = pick_random_state(state_list)
#state 4
func search_state(delta):
	is_searching = true
	animState.travel("Search")
	velocity = Vector2.ZERO
#state 5
func idle_state(delta):
	if is_idle == false:
		is_idle = true
		wanderController.set_wander_timer(rand_range(1,3))
		animState.travel("Idle")
		velocity = Vector2.ZERO

	if  wanderController.get_time_left() == 0:
		state = pick_random_state(state_list)
		is_idle = false
#state 6
func voltar_state(delta):
	if stat.HUNGER <= 1:
		hitbox.disabled = true
		look_and_move(formigueiro.global_position , delta)
	
	var posicao = formigueiro.global_position - global_position
	if posicao > Vector2(0,0) and posicao <= Vector2(2,2):
		queue_free()
	elif posicao < Vector2(0,0) and posicao >= Vector2(2,2) :
		queue_free()
		
		
func attack_animation_finished():
	#state = WANDER
	state = IDLE
	#decidir qual é melhor

func seek_zone():
	if detectionZone.object != null:
		animState.stop()
		state = CHASE


func should_attack():
	#if detectionZone2.can_see_object():
	#	state = EAT
	#EVENTUALMENTE MUDAR ISSO PRA STATE ATTACK, NAO STATE EAT
	pass

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list[1]
	#return state_list.pop_out()

func search_animation_finished():
	state = WANDER
	is_searching = false

func find_food(delta):
	var food = detectionZone2.object
	if food != null:
		var direction = global_position.direction_to(food.global_position)
		look_at(direction * 10000)
		state = EAT
	

		
func morri():
	print("morri")
	queue_free()

func look_and_move(target_position , delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * stat.MAX_SPEED, stat.ACCELERATION * delta)
	look_at(velocity * 10000)
	animState.travel("Walk")
