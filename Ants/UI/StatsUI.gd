extends Control




var mesmo = null
var selected_ant = null

var ANT_COUNT


var GROUP: String
var ANT_ID
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
var MAX_EXP = LEVEL
var HUNGER
var THIRST
var CLASS


onready var typeui = $TypeUI
onready var antid = $AntID
onready var health = $Health
onready var damage = $Damage
onready var speed = $Speed
onready var awareness = $Awareness
onready var dodge = $Dodge
onready var level = $Level
onready var experience = $Experience
onready var hunger = $Hunger
onready var classui = $ClassUI

func set_hp(value):
	CUR_HP = clamp(value, 0, MAX_HP)
	

func _process(_delta):
	
	if selected_ant != null:
		if selected_ant.is_in_group("Ant"):
			self.GROUP = "Ant"
		else:
			self.GROUP = selected_ant.get_groups()[0]
		self.ANT_ID= selected_ant.stat.ANT_ID
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
		self.MAX_EXP = (self.LEVEL)
		self.HUNGER= selected_ant.stat.HUNGER
		self.THIRST= selected_ant.stat.THIRST
		self.CLASS = selected_ant.stat.CLASS
	else:
		queue_free()	
	
	typeui.text = str(GROUP)
	if GROUP == "Ant":
		antid.text = str(ANT_ID)
		classui.text = str(CLASS)
		experience.text = "Exp.: " + str(EXPERIENCE) + "/" + str(MAX_EXP)
		hunger.text = "Hunger: " + str(HUNGER) + "/" + "100"
		damage.text = "Damage: " + str(DAMAGE)
	else: 
		antid.text = " "
		experience.text = " "
		damage.text = "Damage: " + str(DAMAGE) + "x2"
		hunger.text = " "
	health.text = "Health: " + str(CUR_HP) + "/" + str(MAX_HP) 
	speed.text = "Speed: " + str(MAX_SPEED)
	awareness.text = "Awareness: " + str(AWARENESS)
	dodge.text = "Dodge: " + str(DODGE)
	level.text = "Level: " + str(LEVEL) + "/" + str(MAX_LEVEL) 
	
