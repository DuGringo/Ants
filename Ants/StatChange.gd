extends Node2D

enum{
	ROBOT,
	WORKERS,
	WARRIORS
}

onready var dropdown = get_node("StatsMenu/VBoxContainer/DropDown")

export var maxpoints: int = 0 
export var availablepoints: int = 0 setget handle_avalable_points

#priority of wich ant should spawn:
export var warrior_priority = 1
export var worker_priority = 2

var state = ROBOT

#List in order: level modifier, damage modifier, agi modifier
var listrobot: Array = [0, 0, 0]
var listworker: Array = [0, 0, 0]
var listfighter:Array = [0, 0, 0]

# poitns label
onready var availablepointslbl = $"StatsMenu/VBoxContainer/HBoxContainer/Points"

#stats labels
onready var strlbl = $"StatsMenu/VBoxContainer/StrengthMeter/StrengthModifier"
onready var agilbl = $"StatsMenu/VBoxContainer/AgilityMeter/AgilityModifier"

#stas Crystals
onready var agicrystal = $"StatsMenu/VBoxContainer/AgilityMeter/CrystalUI/AgiCrystalsFilled"
onready var strcrystal = $"StatsMenu/VBoxContainer/StrengthMeter/CrystalUI/StrCrystalsFilled"

#for increasing ants capacity
onready var formigueiro = $"../../Formigueiro"

#priority labels
onready var workerslbl = $"StatsMenu/VBoxContainer/WorkersMeter/WorkersModifier"
onready var warriorslbl = $"StatsMenu/VBoxContainer/WarriorsMeter/WarriorsModifier"

#exp bar
onready var expbar = $"StatsMenu/VBoxContainer/ExpContainer/ExpBar"
onready var maxexplbl = $"StatsMenu/VBoxContainer/ExpContainer/MaxExp"

#sound
onready var beep = $Beep

func _ready():
	self.visible = false
	add_items()
	GlobalSignals.connect("gained_exp", self, "handle_gained_exp")


func _input(_event):
#	if Input.is_action_just_pressed("lvl_up"):
#		listworker[0] +=1
#		print("all ants lvl up")
#		pass
#	if Input.is_action_just_pressed("lvl_down"):
#		listworker[0] = clamp(listworker[0] - 1, 0, 99)
#		print(" all ants lvl down")
#		pass
	if Input.is_action_just_pressed("anthill_up"):
		formigueiro.max_ants += 1
		print("bigger anthill")
		pass
	if Input.is_action_just_pressed("anthill_down"):
		formigueiro.max_ants -= 1
		print("smaller anthill")
	if Input.is_action_just_pressed("lvl_up"):
		GlobalSignals.emit_signal("leveledup")


func statchange( stat:int,  valuechange:int, minvalue:int, maxvalue:int,  crystalnode: TextureRect):
	match state:
		ROBOT:
			listrobot[stat] = clamp(listrobot[stat] + valuechange, minvalue,maxvalue)
			change_crystals(crystalnode, listrobot, stat)
		WORKERS:
			listworker[stat] = clamp(listworker[stat] + valuechange, minvalue,maxvalue)
			change_crystals(crystalnode, listworker, stat)
		WARRIORS:
			listfighter[stat] = clamp(listfighter[stat] + valuechange, minvalue,maxvalue)
			change_crystals(crystalnode, listfighter, stat)

func change_crystals(crystalnode: TextureRect, classlist: Array, stat: int):
	crystalnode.rect_size.x = clamp(classlist[stat] * 20, 20, 200)
	if classlist[stat] == 0:
		crystalnode.visible = false
	else:
		crystalnode.visible = true


func add_items():
	dropdown.add_item("Robot Ant")
	dropdown.add_item("Worker Ants")
	dropdown.add_item("Warrior Ants")

	
func handle_avalable_points(new_value):
	availablepoints = clamp(new_value, 0, 20)
	availablepointslbl.text = str(availablepoints)

func check_if_can_change(stat: int):
	match state:
		ROBOT: 
			if listrobot[stat] > 0:
				return true
			else:
				return false 
		WORKERS:
			if listworker[stat] > 0:
				return true
			else:
				return false 
		WARRIORS:
			if listfighter[stat] > 0:
				return true
			else:
				return false
	
func handle_gained_exp():
	expbar.value = formigueiro.anthillexp
	if formigueiro.anthillexp == (formigueiro.anthilllevel * 20):
		maxexplbl.text = str((formigueiro.anthilllevel+1) * 20)
		expbar.max_value = (formigueiro.anthilllevel+1) * 20
		expbar.value = 0
	
func _on_StrLeftButton_pressed():
	if availablepoints < maxpoints and check_if_can_change(1):
		beep.play()
		statchange(1, -1, 0 ,10 , strcrystal )
		handle_avalable_points(availablepoints + 1)

func _on_StrRightButton_pressed():
	if availablepoints > 0:
		beep.play()
		statchange(1, 1, 0 ,10 , strcrystal )
		handle_avalable_points(availablepoints - 1)

func _on_AgiLeftButton_pressed():
	if availablepoints < maxpoints and check_if_can_change(2):
		beep.play()
		statchange(2, -1, 0 ,10 , agicrystal )
		handle_avalable_points(availablepoints + 1)

func _on_AgiRightButton_pressed():
	if availablepoints > 0:
		beep.play()
		statchange(2, 1, 0 ,10 , agicrystal )
		handle_avalable_points(availablepoints - 1)

func _on_DropDown_item_selected(index):
	match index:
		0:
			state = ROBOT
			change_crystals(strcrystal, listrobot, 1)
			change_crystals(agicrystal, listrobot, 2)
		1:
			state = WORKERS
			change_crystals(strcrystal, listworker, 1)
			change_crystals(agicrystal, listworker, 2)
		2:
			state = WARRIORS
			change_crystals(strcrystal, listfighter, 1)
			change_crystals(agicrystal, listfighter, 2)


func _on_WorkersLeftButton_pressed():
	beep.play()
	worker_priority = clamp (worker_priority - 1, 1, 10)
	workerslbl.text = str(worker_priority)

func _on_WorkersRightButton_pressed():
	beep.play()
	worker_priority = clamp (worker_priority + 1, 1, 10)
	workerslbl.text = str(worker_priority)


func _on_WarriorsLeftButton_pressed():
	beep.play()
	warrior_priority = clamp (warrior_priority - 1, 1, 10)
	warriorslbl.text = str(warrior_priority)


func _on_WarriorsRightButton_pressed():
	beep.play()
	warrior_priority = clamp (warrior_priority + 1, 1, 10)
	warriorslbl.text = str(warrior_priority)
