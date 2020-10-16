extends KinematicBody2D

enum{
	ATTACK,
	CHASE,
	WANDER,
	IDLE
}


var state = null
var velocity = Vector2.ZERO
export(int) var proximity_range = 2

var is_idle = false
var is_attacking = false

var obj_pos = null

var state_list = [WANDER, WANDER, IDLE]

#vai conter, em ordem, top left, top right, bottom left, bottom right
var area = []


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
#collision shape para area que a formiga vai
onready var collisionshape = $CollisionShape2D

#for creating food when it dies
onready var FoodCube = load("res://Actors/Food/Food.tscn")
onready var foodCube = FoodCube.instance()
onready var world = get_tree().current_scene

func _ready():
	randomize()
	rand_stat()
	animTree.active = true
	
	state = IDLE
	


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
func attack_state(_delta):
	is_attacking = true
	is_idle = false
	
	animState.travel("Attack")
	velocity = Vector2.ZERO
#state 1
func chase_state(delta):
	is_idle = false
	
	look_and_move(obj_pos , delta)
	animState.travel("Walk")

	
	if is_it_close(global_position, obj_pos, proximity_range):
		velocity = Vector2.ZERO
		animState.travel("Idle")
		state = pick_random_state(state_list)
#state 2
func wander_state(delta):
	is_idle = false

	if wanderController.get_time_left() <= .5:
		state = pick_random_state(state_list)
		wanderController.set_wander_timer(rand_range(1,7))

	look_and_move(wanderController.target_position , delta)
	animState.travel("Walk")
		
	
	if global_position.distance_to(wanderController.target_position) <= proximity_range:
				velocity = Vector2.ZERO
				animState.travel("Idle")
				state = pick_random_state(state_list)
#state 3
func idle_state(_delta):
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
	
	stat.LEVEL = get_tree().current_scene.get_node("Formigueiro").strongest_ant
	
	
	
	
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
	stat.DAMAGE = 1 + (stat.LEVEL/4)
	hitdamage.damage = stat.DAMAGE
	
	stat.MAX_HP = stat.MAX_HP * (1 + stat.LEVEL/4)
	stat.CUR_HP = stat.MAX_HP
	
	#CLASS SPECIFIC
	#almenta o tamanho da formiga baseado no level
	scale = scale + Vector2(stat.LEVEL * 0.07 , stat.LEVEL * 0.07)
	#almenta o range que anda conforme awareness
	wanderController.wander_range = wanderController.wander_range * (0.5 * stat.LEVEL) 
	
	

func attack_animation_finished():
	state = IDLE
	is_attacking = false
	
func seek_zone():
	if detectionZone.object != null:
		animState.stop()
		obj_pos = detectionZone.object.global_position
		if detectionZone.object.get_groups()[0] == "Food":
			obj_pos = Vector2(obj_pos.x , obj_pos.y + 20)
		state = CHASE

func pick_random_state(statelist):
	statelist.shuffle()
	return statelist[0]
	
func find_food(_delta):
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
	#limite - 10^(-(x-taxa*log(limite)/taxa))
	for _x in range (0, rand_range(1, stat.LEVEL*2) )  :
#	for x in range (0, 40 - pow(10,(-(stat.LEVEL -20*log(40)/20)))):
		world.add_child(foodCube)
		foodCube.position = global_position + Vector2(rand_range(-10,10), rand_range(-10,10))
		foodCube.valor_nutricional = foodCube.valor_nutricional * (1 + stat.LEVEL * 0.5)
		foodCube.stat.MAX_HP = foodCube.stat.MAX_HP * (1 + stat.LEVEL * 0.5)
		foodCube.stat.CUR_HP = foodCube.stat.MAX_HP
	queue_free()


func _on_Stats_loosing_health():
	if is_attacking == false:
		state = ATTACK
