extends Node2D

export var Max_HP = 1
export var Cur_HP = 1
export var ACCELERATION = 800
export var MAX_SPEED = 100
export var FRICTION = 500

export var DAMAGE = 1
export var AWARENESS = 1
export var DODGE = 1

export var MAX_LEVEL = 1
export var LEVEL = 1
export var EXPERIENCE = 0

export var HUNGER = 1
export var THIRST = 1

func _process(delta):
	if HUNGER < 1 : HUNGER = 1
	if HUNGER > 100 : HUNGER = 100
	if THIRST < 1 : THIRST = 1
	if THIRST > 100: HUNGER = 100
	
