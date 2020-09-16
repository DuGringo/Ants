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


var state = null
var velocity = Vector2.ZERO
export(int) var proximity_range = 2

var is_searching = false
var is_idle = false

var obj_pos = null
var valor_nutricional = null

var state_list = [WANDER, WANDER, WANDER, WANDER, IDLE, IDLE, IDLE, SEARCH]

onready var anim : AnimationPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
#onready var formigueiro = $Formigueiro
onready var formigueiro = get_node("../Formigueiro")
onready var hitbox = get_node("Hitbox/CollisionShape2D")

#usado em Formigueiro para dar update no dano da formiga
onready var hitdamage = $Hitbox

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


func _ready():
	randomize()
	animTree.active = true
	state = pick_random_state(state_list)
	self.rotation_degrees = rand_range(0, 360)
	
	#nasce uma formiga existente ao invez de nova
	if formigueiro.formigas.size() > 0: 
			formigueiro.formigas.shuffle()
			set_stat()
	else:
		formigueiro.antnumber += 1
		stat.ANT_NUMBER = formigueiro.antnumber
			

	
	

	
	
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

			seek_zone()
			fix_cone()
			chase_state(delta)
			detect_and_look(delta)
#state 2
		EAT:

			eat_state(delta)
#state 3
		WANDER:

			fix_cone()
			seek_zone()
			wander_state(delta)
			detect_and_look(delta)
#state 4
		SEARCH:

			seek_zone()
			search_state(delta)
			detect_and_look(delta)
#state 5
		IDLE:

			fix_cone()
			seek_zone()
			idle_state(delta)
			detect_and_look(delta)
#state 6
		VOLTAR:
			fix_cone()
			voltar_state(delta)

	#colisao
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	#se meche por causa disso:
	velocity = move_and_slide(velocity)
	#decide se volta pro formigueiro
	if stat.HUNGER <= 1:
		state = VOLTAR	
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
	is_searching = false
	is_idle = false
	
	animState.travel("Attack")
	velocity = Vector2.ZERO
#state 1
func eat_state(delta):
	is_searching = false
	is_idle = false
	animState.travel("Attack")
	velocity = Vector2.ZERO
#state 2
func chase_state(delta):
	is_searching = false
	is_idle = false
	
	var object = detectionZone.object
	
	look_and_move(obj_pos , delta)
	animState.travel("Walk")
	should_attack()
	
	if is_it_close(global_position, obj_pos, proximity_range):
		velocity = Vector2.ZERO
		animState.travel("Idle")
		state = pick_random_state(state_list)
#state 3
func wander_state(delta):
	is_idle = false

	if is_searching != true:
		if wanderController.get_time_left() == 0:
			state = pick_random_state(state_list)
			wanderController.set_wander_timer(rand_range(1,2))
		look_and_move(wanderController.target_position , delta)
		animState.travel("Walk")
		
	
	if global_position.distance_to(wanderController.target_position) <= proximity_range:
				velocity = Vector2.ZERO
				animState.travel("Idle")
				state = pick_random_state(state_list)
#state 4
func search_state(delta):
	is_idle = false
	is_searching = true
	
	animState.travel("Search")
	velocity = Vector2.ZERO
#state 5
func idle_state(delta):
	is_searching = false
	#vector zero aqui para a formiga parar de ser empurrada enquanto estiver idle
	velocity = Vector2.ZERO

	if is_idle == false:
		is_searching = false
		is_idle = true
		wanderController.set_wander_timer(rand_range(1,3))
		animState.travel("Idle")
#		velocity = Vector2.ZERO

	if  wanderController.get_time_left() == 0:
		state = pick_random_state(state_list)
		is_idle = false
#state 6
func voltar_state(delta):
	is_searching = false
	is_idle = false
	if stat.HUNGER <= 1:
		hitbox.disabled = true
		look_and_move(Vector2(formigueiro.global_position.x, formigueiro.global_position.y +20) , delta)
		animState.travel("Walk Leaf")
	if is_it_close(Vector2(formigueiro.global_position.x, formigueiro.global_position.y +20), global_position, proximity_range):
		queue_free()

#funcoes
func set_stat():
	var ant_stat = formigueiro.formigas[0].duplicate(true)
	stat.ANT_NUMBER = ant_stat[0]
	stat.MAX_HP = ant_stat[1]
	stat.CUR_HP = ant_stat[2]
	stat.ACCELERATION = ant_stat[3]
	stat.MAX_SPEED = ant_stat[4]
	stat.FRICTION = ant_stat[5]
	stat.AWARENESS = ant_stat[6]
	stat.DAMAGE = ant_stat[7]
	stat.DODGE = ant_stat[8]
	stat.MAX_LEVEL = ant_stat[9]
	stat.LEVEL = ant_stat[10]
	stat.EXPERIENCE = ant_stat[11]
	#fome fixa por enquanto
	#ant.stat.HUNGER = ant_stat[12]
	stat.HUNGER = 50
	stat.THIRST = ant_stat[13]
	stat.need_level_up = ant_stat[14]
		
	formigueiro.formigas.remove(0)
	if stat.ANT_NUMBER == 0:
		stat.ANT_NUMBER += 1
		formigueiro.antnumber = stat.ANT_NUMBER
		
	#CLASS SPECIFIC
	#da o dano certo para HitZone
	hitdamage.damage = stat.DAMAGE
	#CLASS SPECIFIC
	#almenta o tamanho da do campo de visao baseado AWARENESS level
	detectionZone.scale = detectionZone.scale + Vector2(stat.AWARENESS/10, stat.AWARENESS/10)
	#almenta o tamanho da formiga baseado no level
	scale = scale + Vector2(stat.LEVEL / 7 , stat.LEVEL / 7)
	#almenta o range que anda conforme awareness
	wanderController.wander_range = wanderController.wander_range * (1 * stat.LEVEL) 

func attack_animation_start():
	var object = detectionZone2.object
	if object != null:
		if object.stat.CLASS == "Food":
			valor_nutricional = object.valor_nutricional

func attack_animation_finished():
		#fix porco de um bug
		if valor_nutricional != null:
			stat.HUNGER = stat.HUNGER - valor_nutricional
		state = IDLE

func seek_zone():
	if detectionZone.object != null:
		animState.stop()
		obj_pos = detectionZone.object.global_position
		if detectionZone.object.stat.CLASS == "Food":
			obj_pos = Vector2(obj_pos.x , obj_pos.y + 20)
		state = CHASE

func should_attack():
	#if detectionZone2.can_see_object():
	#	state = EAT
	#EVENTUALMENTE MUDAR ISSO PRA STATE ATTACK, NAO STATE EAT
	pass

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list[1]

func search_animation_finished():
	state = WANDER
	is_searching = false

		
func detect_and_look(delta):
	var object = detectionZone2.object
	if object != null:
		var direction = global_position.direction_to(Vector2(object.global_position.x, object.global_position.y + 20))
		look_at(direction * 10000)
		if object.stat.CLASS == "Food":
			state = EAT
		if object.stat.CLASS == "Enemy":
			state = ATTACK
			

func look_and_move(target_position , delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * stat.MAX_SPEED, stat.ACCELERATION * delta)
	look_at(velocity * 10000)
	#É aqui que chamava a animacao de andar antes, e nao precisava de outras!
#	animState.travel("Walk")

func fix_cone():
	detectionZone.rotation = 0
	detectionZone.scale = Vector2(1,1)

func is_it_close(pos1, pos2, distance):
	var posicao = pos1 - pos2
	if posicao.length() <= distance:
		return true

func gain_exp():
	if stat.LEVEL < stat.MAX_LEVEL:
		if stat.EXPERIENCE < stat.LEVEL * 5:
			stat.EXPERIENCE += 1
	




func _on_HurtBox_area_entered(attack):
	stat.CUR_HP -= attack.damage

func _on_Stats_no_health():
	queue_free()

func _on_Stats_low_health():
	state = VOLTAR
