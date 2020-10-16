extends KinematicBody2D

	
#se modificar, modifique tambem em pherormone
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


export(int) var proximity_range = 16


var state = null
var velocity = Vector2.ZERO
var distance_to_walk = Vector2.ZERO

var path = PoolVector2Array()


var is_searching = false setget fix_cone
var is_idle = false
var is_chase = false
var is_voltando = false

var phero_obj_dir setget follow_pherormone
var pheroid = null
var last_chased_object_pos = null


var obj_pos = null
var valor_nutricional = null
var direction = null

#para lancar ferormonio quando entra no formigueiro
var last_position = null

#para criacao e manipulacao de ferormonio
var ferormonio_criado: bool = false
var ferormonio = null
var ferormonio_encontrado = false

#para saber se segue ou nao o ferormonio
var posicao_atual: Vector2 = Vector2.ZERO
var obj_type = null
var phero_obj_type = null


var modifier: Array = []

var state_list = [WANDER, WANDER, WANDER, WANDER, IDLE, IDLE, IDLE, SEARCH]

onready var anim : AnimationPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState = animTree.get("parameters/playback")
#onready var formigueiro = $Formigueiro
onready var formigueiro = get_node("../Formigueiro")
onready var hitbox = get_node("Hitbox/CollisionShape2D")

onready var pathfinding = get_node("../Pathfinding")

onready var ferormonios = get_node("../Ferormonios")

onready var colisao = get_node("CollisionShape2D")



#usado em Formigueiro para dar update no dano da formiga
onready var hitdamage = $Hitbox

#Stats
onready var stat = $Stats
#Stats modifiers for lvl up
onready var statchange = $"../CanvasLayer/StatChange"
#Finding
onready var detectionZone = $DetectionZone
#Attack
onready var detectionZone2 = $DetectionZone2
#Wander
onready var wanderController = $WanderController
#soft Collistion
onready var softCollision = $SoftCollision





func _ready():
#	self.modulate = Color(1,1,1)
	randomize()
	animTree.active = true
	state = WANDER
	self.rotation_degrees = rand_range(0, 2 * PI)
	
	
	#nasce uma formiga existente ao invez de nova
	if rand_range(0, formigueiro.ants_count) < formigueiro.formigas.size(): 
			formigueiro.formigas.shuffle()
			set_stat()
	else:
		formigueiro.ant_id += 1
		stat.ANT_ID = formigueiro.ant_id
		if 2*formigueiro.warriorcount < formigueiro.workercount:
			stat.CLASS = "Fighter"
			formigueiro.warriorcount +=1
		else: 
			stat.CLASS = "Worker"
			formigueiro.workercount += 1

		apply_modifier()



	
	

	
	
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
			seek_zone(delta)
			chase_state(delta)

			
#state 2
		EAT:
			eat_state(delta)
#state 3
		WANDER:
			seek_zone(delta)
			wander_state(delta)

#state 4
		SEARCH:
			seek_zone(delta)
			search_state(delta)

#state 5
		IDLE:
			seek_zone(delta)
			idle_state(delta)

#state 6
		VOLTAR:
			voltar_state(delta)
	
	
	
		#colisao , usado somente enquanto esta movendo
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 40
	
		#se meche por causa disso:
	velocity = move_and_slide(velocity)

	
	#decide se volta pro formigueiro
	if stat.HUNGER <= 1 or stat.CUR_HP <= stat.MAX_HP/2:
		if is_voltando == false:
			last_position = global_position
			is_voltando = true
		state = VOLTAR	


#state 0
func attack_state(_delta):
	is_searching = false
	is_idle = false
	animState.travel("Attack")
	velocity = Vector2.ZERO
	is_chase = false
#state 1
func eat_state(_delta):
	is_searching = false
	is_idle = false
	animState.travel("Attack")
	velocity = Vector2.ZERO
	is_chase = false
#state 2
func chase_state(delta):
	is_searching = false
	is_idle = false
	if is_chase == false and detectionZone.object != null and global_position.distance_to(obj_pos) >= 8:
		release_pherormon(obj_pos, obj_type)
		is_chase = true
		if detectionZone.object != null:
			last_chased_object_pos = detectionZone.object.global_position 
			
	look_and_move(obj_pos, delta, 6)

	animState.travel("Walk")

	#teste para ver se entra aqui.
	if is_it_close(global_position, obj_pos, proximity_range):
		velocity = Vector2.ZERO
		animState.travel("Idle")
		state = pick_random_state(state_list)
#state 3
func wander_state(delta):
	is_idle = false
	is_chase = false

	if is_searching != true:
		wanderController.update_target_position()
		if wanderController.get_time_left() == 0:
			state = pick_random_state(state_list)
			wanderController.set_wander_timer(rand_range(1,2))
		look_and_move(wanderController.target_position , delta, 8)
		
		animState.travel("Walk")
		
	
	if global_position.distance_to(wanderController.target_position) <= proximity_range:
				velocity = Vector2.ZERO
				animState.travel("Idle")
				state = pick_random_state(state_list)
#state 4
func search_state(_delta):
	is_idle = false
	is_searching = true
	is_chase = false
	
	animState.travel("Search")
	velocity = Vector2.ZERO
#state 5
func idle_state(_delta):
	is_chase = false
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
	is_chase = false
	is_searching = false
	is_idle = false
	if stat.HUNGER <= 1 or stat.CUR_HP <= stat.MAX_HP/2:
		hitbox.disabled = true
		look_and_move(formigueiro.global_position, delta, 4)
		
		animState.travel("Walk Leaf")
	if is_it_close(formigueiro.global_position, global_position, 30):
		queue_free()
		release_pherormon(last_position, obj_type)
		formigueiro.antout -= 1

#funcoes
func set_stat():
	var ant_stat = formigueiro.formigas[0].duplicate(true)
	stat.ANT_ID = ant_stat[0]
	stat.MAX_HP = ant_stat[1]
	stat.CUR_HP = stat.MAX_HP
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
	stat.HUNGER = 100
	stat.THIRST = ant_stat[13]
	stat.need_level_up = ant_stat[14]
	stat.CLASS = ant_stat[15]
		
	formigueiro.formigas.remove(0)
	if stat.ANT_ID == 0:
		stat.ANT_ID += 1
		formigueiro.antid = stat.ANT_ID

	apply_modifier()
	

	#da o dano certo para HitZone
	hitdamage.damage = stat.DAMAGE

	#almenta o tamanho da do campo de visao baseado AWARENESS level
	detectionZone.scale = detectionZone.scale + Vector2(stat.AWARENESS, stat.AWARENESS)
	#almenta o tamanho da formiga baseado no level
	if stat.CLASS == "Worker":
		scale = scale + Vector2(stat.LEVEL * 0.05 , stat.LEVEL * 0.05)
	if stat.CLASS == "Fighter":
		scale = scale + Vector2(stat.LEVEL * 0.1 , stat.LEVEL * 0.1)
	#almenta o range que anda conforme awareness
	wanderController.wander_range = 32 * (stat.LEVEL/10) 

func attack_animation_start():
	var object = detectionZone2.object
	if object != null:
		if object.is_in_group("Food"):
			valor_nutricional = object.valor_nutricional

func attack_animation_finished():
		#fix porco de um bug
		if valor_nutricional != null:
			stat.HUNGER = stat.HUNGER - valor_nutricional
			valor_nutricional = 0
		state = IDLE

func seek_zone(delta):
	if detectionZone.object != null and detectionZone2.object == null:
		animState.stop()
		obj_pos = get_random_position_within_target_radius()
		if detectionZone.object.is_in_group("Food"):
			obj_type = "Food"
		if detectionZone.object.is_in_group("Enemy"):
			obj_type = "Enemy"
		if state != CHASE:
			state = CHASE
	elif detectionZone.object != null and detectionZone2.object != null:
		detect_and_look(delta)

func pick_random_state(statelist):
	statelist.shuffle()
	return statelist[1]

func search_animation_finished():
	state = WANDER
	is_searching = false

		
func detect_and_look(_delta):
	var object = detectionZone2.object
	if object != null:
		direction = global_position.direction_to(object.global_position)
		look_at(direction * 10000)
		if object.is_in_group("Food"):
			state = EAT
		if object.is_in_group("Enemy"):
			state = ATTACK
		if object.is_in_group("Ant") and detectionZone.object != null:
			obj_pos = get_random_position_within_target_radius()
			
			
			


func look_and_move(target_position ,  delta, proximity):

#		#colisao , usado somente enquanto esta movendo
#	if softCollision.is_colliding():
#		velocity += softCollision.get_push_vector() * delta * 500
	if path.size() < 2 or path == null or softCollision.is_colliding() or self.is_on_wall():
		path = pathfinding.get_new_path(global_position, target_position)
	get_closer(delta, proximity)


func get_closer(delta, proximity):
	if path.size() > 1:
		velocity = global_position.direction_to(path[1]) * stat.MAX_SPEED * stat.ACCELERATION * delta
		rotation = lerp(rotation, global_position.direction_to(path[1]).angle(), 0.20)
		#Mechendo aqui
		if is_it_close(global_position, path[1], 4):
			path.remove(1)
			
			#esse else estava vazio e o conteudo acida desse comentario (dentro do if)
		else:
#			if path.size() >= 2:
#				get_closer(delta , proximity)
#			else:
#				get_closer(delta, 4)
			pass
	#re-habilitar, foi desabilitado para testar final de pathfinding
#	elif path.size() == 1:
#		rotation = lerp(rotation, global_position.direction_to(path[0]).angle(), 0.08)	
	elif path.size() == 1:
		if is_it_close(global_position, path[0], proximity):
			velocity = Vector2.ZERO
			animState.travel("Idle")
			state = pick_random_state(state_list)

func is_it_close(pos1, pos2, distance):
	var posicao = pos1 - pos2
	if posicao.length() <= distance:
		return true


func fix_cone(value):
	if value == false:
		detectionZone.rotation = 0
		detectionZone.disabled = false
	is_searching = value


func gain_exp():
	if stat.LEVEL < stat.MAX_LEVEL:
		if stat.EXPERIENCE < stat.LEVEL:
			stat.EXPERIENCE += 1

func release_pherormon(target_position, objtype):

	if ferormonio_encontrado == true and ferormonio != null:
		ferormonio.timer.start(4)
		ferormonio.posicao = target_position
		ferormonio.global_position = global_position
		ferormonio.collisionshape.disabled = false
		#a formiga que esta soltando um ferormonio sem seguir/sem ver, n sabe onde o objeto esta
		if detectionZone.object != null:
			ferormonio.objid = detectionZone.object.global_position 
		else:
			ferormonio.objid = target_position
		ferormonio.state = CHASE
		ferormonio.objtype = objtype


	elif ferormonio_encontrado == false and ferormonio_criado == true:
		for child in int(ferormonios.get_child_count()):
			if ferormonios.get_children()[child].id == "Pherormone" + str(stat.ANT_ID):
				ferormonio = ferormonios.get_child(child)
				ferormonio_encontrado = true
				release_pherormon(target_position, objtype)
				pass

	elif ferormonio_criado == false or ferormonios.get_child_count() == 0 :
		var Pherormone = load("res://Zones/Pherormone.tscn")
		var pherormone = Pherormone.instance()
		ferormonios.add_child(pherormone)
		pherormone.id = pherormone.id + str(stat.ANT_ID)
		ferormonio_criado = true
		release_pherormon(target_position, objtype)
		pass
	else:
		print("Ferormonio nao foi criado e nao existe")

func follow_pherormone(new_value):
	if pheroid != last_chased_object_pos:
		#can probably cut this short. remove the middleman. obj_pos = new value .
		phero_obj_dir = new_value
		obj_pos = phero_obj_dir
		last_chased_object_pos = pheroid
		obj_type = phero_obj_type
		if stat.CLASS == "Worker" and phero_obj_type == "Food":
			if state != CHASE:
				state = CHASE
		elif stat.CLASS == "Fighter" and phero_obj_type == "Enemy":
			if state != CHASE:
				state = CHASE
		else:
			release_pherormon(obj_pos, obj_type)
#			state = pick_random_state(state_list)
	else:
		pass
		


func apply_modifier():
	if stat.CLASS == "Worker":
		modifier = statchange.listworker
	if stat.CLASS == "Fighter":
		modifier = statchange.listfighter
	
#	stat.LEVEL = stat.LEVEL + modifier[0]
	stat.DAMAGE = 1 * ( 1 + (modifier[0] + stat.LEVEL))

	stat.MAX_SPEED = 50 *  (1 + (modifier[1] + stat.LEVEL)/10)
# isso 'e igual a 201.6 no lvl 5.

#trocar para ser a area redonda ao invez da quadrada
func get_random_position_within_target_radius() -> Vector2:
#	var extents = Vector2.ZERO
	var radius: float = detectionZone.object.collisionshape.shape.radius
#	if detectionZone.object.is_in_group("Food"):
#		extents = detectionZone.object.collisionshape.shape.extent
#	if detectionZone.object.is_in_group("Enemy"):
#		extents = detectionZone.object.collisionshape.shape.extents
#	var topleft = detectionZone.object.collisionshape.global_position - (extents / 2)
	var center = detectionZone.object.collisionshape.global_position
	var angle  = rand_range(0 ,2 * PI)
	var x = center.x + radius * cos(angle)
	var y = center.y + radius * sin(angle)
#	var x = rand_range(topleft.x , topleft.x+ extents.x)
#	var y = rand_range(topleft.y , topleft.y+ extents.y)
	return Vector2(x, y)
	
func _on_HurtBox_area_entered(attack):
	stat.CUR_HP -= attack.damage

func _on_Stats_no_health():
	queue_free()
	formigueiro.antout -= 1
	if ferormonio != null:
		ferormonio.queue_free()
