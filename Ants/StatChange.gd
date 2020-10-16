extends Node2D

enum{
	WORKERS,
	FIGHTERS
}

onready var dropdown = get_node("StatsMenu/VBoxContainer/DropDown")

export var availablepoints: int = 10


var state = WORKERS


#List in order: level modifier, damage modifier
var listworker: Array = [0, 0]
var listfighter:Array = [0, 0]



#stats labels
onready var strlbl = $"StatsMenu/VBoxContainer/StrengthMeter/StrengthModifier"
onready var agilbl = $"StatsMenu/VBoxContainer/AgilityMeter/AgilityModifier"
#for increasing ants capacity
onready var formigueiro = $"../../Formigueiro"




func _ready():
	self.visible = false
	add_items()


func _input(_event):
	if Input.is_action_just_pressed("lvl_up"):
		listworker[0] +=1
		print("all ants lvl up")
		pass
	if Input.is_action_just_pressed("lvl_down"):
		listworker[0] = clamp(listworker[0] - 1, 0, 99)
		print(" all ants lvl down")
		pass
	if Input.is_action_just_pressed("anthill_up"):
		formigueiro.max_ants += 1
		print("bigger anthill")
		pass
	if Input.is_action_just_pressed("anthill_down"):
		formigueiro.max_ants -= 1
		print("smaller anthill")


func statchange( stat:int,  valuechange:int, minvalue:int, maxvalue:int, labelnode: Label):
	match state:
		WORKERS:
			listworker[stat] = clamp(listworker[stat] + valuechange, minvalue,maxvalue)
			change_label(labelnode, listworker, stat)
		FIGHTERS:
			listfighter[stat] = clamp(listfighter[stat] + valuechange, minvalue,maxvalue)
			change_label(labelnode, listfighter, stat)

func change_label(labelnode: Label, classlist: Array, stat: int):
	labelnode.text = str(classlist[stat])

func add_items():
	dropdown.add_item("Worker Ants")
	dropdown.add_item("Fighter Ants")

func _on_StrLeftButton_pressed():
	statchange(0, -1, 0 ,10 , strlbl )

func _on_StrRightButton_pressed():
	statchange(0, 1, 0 ,10 , strlbl )

func _on_AgiLeftButton_pressed():
	statchange(1, -1, 0 ,10 , agilbl )

func _on_AgiRightButton_pressed():
	statchange(1, 1, 0 ,10 , agilbl )

func _on_DropDown_item_selected(index):
	match index:
		0:
			state = WORKERS
			change_label(strlbl, listworker, 0)
			change_label(agilbl, listworker, 1)
		1:
			state = FIGHTERS
			change_label(strlbl, listfighter, 0)
			change_label(agilbl, listfighter, 1)
