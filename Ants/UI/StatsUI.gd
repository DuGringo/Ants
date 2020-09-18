extends Control
var mesmo = null
var selected_ant = null

var ANT_COUNT

var CLASS
var ANT_NUMBER
var MAX_HP
var CUR_HP setget set_hp
var ACCELERATION
var MAX_SPEED
var FRICTION
var AWARENESS
var DAMAGE
var DODGE
var MAX_LEVEL
var LEVEL = 1
var EXPERIENCE 
var MAX_EXP = LEVEL * 2
var HUNGER
var THIRST


onready var classui = $ClassUI
onready var antnumber = $"Ant Number"
onready var health = $Health
onready var damage = $Damage
onready var speed = $Speed
onready var awareness = $Awareness
onready var dodge = $Dodge
onready var level = $Level
onready var experience = $Experience
onready var hunger = $Hunger

func set_hp(value):
	CUR_HP = clamp(value, 0, MAX_HP)

	

func _process(delta):
	
	if selected_ant != null:
		self.CLASS = selected_ant.stat.CLASS
		self.ANT_NUMBER= selected_ant.stat.ANT_NUMBER
		self.MAX_HP= selected_ant.stat.MAX_HP
		self.CUR_HP= selected_ant.stat.CUR_HP
		self.ACCELERATION= selected_ant.stat.ACCELERATION
		self.MAX_SPEED= selected_ant.stat.MAX_SPEED
		self.FRICTION= selected_ant.stat.FRICTION
		self.AWARENESS= selected_ant.stat.AWARENESS
		self.DAMAGE= selected_ant.stat.DAMAGE
		self.DODGE= selected_ant.stat.DODGE
		self.MAX_LEVEL= selected_ant.stat.MAX_LEVEL
		self.LEVEL= selected_ant.stat.LEVEL
		self.EXPERIENCE= selected_ant.stat.EXPERIENCE
		self.MAX_EXP = (self.LEVEL * 2)
		self.HUNGER= selected_ant.stat.HUNGER
		self.THIRST= selected_ant.stat.THIRST
	else:
		queue_free()	
	
	classui.text = str(CLASS)
	if CLASS == "Ant":
		antnumber.text = str(ANT_NUMBER)
		experience.text = "Exp.: " + str(EXPERIENCE) + "/" + str(MAX_EXP)
		hunger.text = "Hunger: " + str(HUNGER) + "/" + "100"
		damage.text = "Damage: " + str(DAMAGE)
	else: 
		antnumber.text = " "
		experience.text = " "
		damage.text = "Damage: " + str(DAMAGE) + "x2"
		hunger.text = " "
	health.text = "Health: " + str(CUR_HP) + "/" + str(MAX_HP) 
	speed.text = "Speed: " + str(MAX_SPEED)
	awareness.text = "Awareness: " + str(AWARENESS)
	dodge.text = "Dodge: " + str(DODGE)
	level.text = "Level: " + str(LEVEL) + "/" + str(MAX_LEVEL) 
	
