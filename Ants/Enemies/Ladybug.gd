extends KinematicBody2D

enum{
	ATTACK,
	CHASE,
	WANDER,
	IDLE
}


var state = null
var velocity = Vector2.ZERO
export(int) var proximity_range = 10

var is_idle = false
var is_attacking = false

var obj_pos = null

var state_list = [WANDER, IDLE]


onready var anim : AnimationPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
onready var hitbox = get_node("Hitbox/CollisionShape2D")

#Stats
onready var stat = $Stats
#Finding
onready var detectionZone = $DetectionZone
#Attack
onready var detectionZone2 = $DetectionZone2
#Wander
onready var wanderController = $WanderController
#soft Collistion
onready var softCollision = $SoftCollision
#hitbox damage
onready var hitdamage = $Hitbox


func _ready():
	randomize()
	rand_stat()
	animTree.active = true
	state = WANDER

func _physics_process(delta):
	match state:
#state 0
		ATTACK:
			attack_state(delta)
#stat1 
		CHASE:
			seek_zone()
			chase_state(delta)
			find_food(delta)
#state 2
		WANDER:
			seek_zone()
			wander_state(delta)
			find_food(delta)
#state 3
		IDLE:
			seek_zone()
			idle_state(delta)
			find_food(delta)

	#colisao
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	#se meche por causa disso:
	velocity = move_and_slide(velocity)


#state 0
func attack_state(delta):
	is_attacking = true
	is_idle = false
	
	animState.travel("Attack")
	velocity = Vector2.ZERO
#state 1
func chase_state(delta):
	is_idle = false
	
	var object = detectionZone.object
	
	look_and_move(obj_pos , delta)
	animState.travel("Walk")

	
	if is_it_close(global_position, obj_pos, proximity_range):
		velocity = Vector2.ZERO
		animState.travel("Idle")
		state = pick_random_state(state_list)
#state 2
func wander_state(delta):
	is_idle = false

	if wanderController.get_time_left() == 0:
		state = pick_random_state(state_list)
		wanderController.set_wander_timer(rand_range(1,10))
	look_and_move(wanderController.target_position , delta)
	animState.travel("Walk")
		
	
	if global_position.distance_to(wanderController.target_position) <= proximity_range:
				velocity = Vector2.ZERO
				animState.travel("Idle")
				state = pick_random_state(state_list)
#state 3
func idle_state(delta):
	#vector zero aqui para a formiga parar de ser empurrada enquanto estiver idle
	velocity = Vector2.ZERO

	if is_idle == false:
		is_idle = true
		wanderController.set_wander_timer(rand_range(1,3))
		animState.travel("Idle")
#		velocity = Vector2.ZERO

	if  wanderController.get_time_left() == 0:
		state = pick_random_state(state_list)
		is_idle = false

#funcoes
func rand_stat():
#	stat.MAX_HP = ant_stat[1]
#	stat.CUR_HP = ant_stat[2]
#	stat.ACCELERATION = ant_stat[3]
#	stat.MAX_SPEED = ant_stat[4]
#	stat.FRICTION = ant_stat[5]
#	stat.AWARENESS = ant_stat[6]
#	stat.DAMAGE = ant_stat[7]
#	stat.DODGE = ant_stat[8]
#	stat.MAX_LEVEL = ant_stat[9]
#	stat.LEVEL = ant_stat[10]
#	stat.EXPERIENCE = ant_stat[11]
#	#fome fixa por enquanto
#	#ant.stat.HUNGER = ant_stat[12]
#	stat.HUNGER = 50
#	stat.THIRST = ant_stat[13]
#	stat.need_level_up = ant_stat[14]
		
	#CLASS SPECIFIC
	#da o dano certo para HitZone
	hitdamage.damage = stat.DAMAGE
	#CLASS SPECIFIC
	#almenta o tamanho da formiga baseado no level
	scale = scale + Vector2(stat.LEVEL / 7 , stat.LEVEL / 7)
	#almenta o range que anda conforme awareness
	wanderController.wander_range = wanderController.wander_range * (1 * stat.LEVEL) 

func attack_animation_finished():
	state = IDLE
	is_attacking = false
	
func seek_zone():
	if detectionZone.object != null:
		animState.stop()
		obj_pos = detectionZone.object.global_position
		if detectionZone.object.stat.CLASS == "Food":
			obj_pos = Vector2(obj_pos.x , obj_pos.y + 20)
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list[1]
	
func find_food(delta):
	var food = detectionZone2.object
	if food != null:
		var direction = global_position.direction_to(Vector2(food.global_position.x, food.global_position.y + 20))
		look_at(direction * 10000)
		state = ATTACK
		
func look_and_move(target_position , delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * stat.MAX_SPEED, stat.ACCELERATION * delta)
	look_at(velocity * 10000)
	
func is_it_close(pos1, pos2, distance):
	var posicao = pos1 - pos2
	if posicao.length() <= distance:
		return true

func _on_HurtBox_area_entered(attack):
	stat.CUR_HP -= attack.damage

func _on_Stats_no_health():
	queue_free()


func _on_Stats_loosing_health():
	if is_attacking == false:
		state = ATTACK