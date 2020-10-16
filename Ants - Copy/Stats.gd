extends Node2D

export var TYPE = "Ant"
export var ANT_ID = 0
export var MAX_HP = 1
export var CUR_HP = 1 setget set_health
export var ACCELERATION = 800
export var MAX_SPEED = 100
export var FRICTION = 500

#For DAMAGE, refer to HITBOX
export var AWARENESS = 1.0
export var DAMAGE = 1 
export var DODGE = 1.0

export var MAX_LEVEL = 10.0
export var LEVEL = 1.0 
export var EXPERIENCE = 0

export var HUNGER = 1 setget set_hunger
export var THIRST = 1 setget set_thirst

var need_level_up = false

export var CLASS = "Worker"

signal no_health
signal is_hungry
signal is_thirsty
signal loosing_health

func set_health(value):
	CUR_HP = value
	emit_signal("loosing_health")
	if CUR_HP <= 0 :
		CUR_HP = 0
		emit_signal("no_health")

func set_hunger(value):
	HUNGER = value
	if HUNGER < 1 : HUNGER = 1
	if HUNGER > 100 : HUNGER = 100

func set_thirst(value):
	THIRST = value
	if THIRST < 1 : THIRST = 1
	if THIRST > 100: HUNGER = 100

func level_up():
	LEVEL += 1
	EXPERIENCE = 0
	#if CLASS = <raca da formiga, classe da formiga, etc>
	DAMAGE += 1
	AWARENESS += 1
	MAX_HP +=1
	CUR_HP += 1
	need_level_up = false

func _process(delta):
	if need_level_up:
		level_up() 
	
	
